Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1GOQYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:24:07 -0400
Received: from mail.lang.hm ([64.81.33.126]:43095 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1GOQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:24:05 -0400
Date: Fri, 15 Jul 2011 09:23:45 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Chris Mason <chris.mason@oracle.com>
cc: Ric Wheeler <rwheeler@redhat.com>, NeilBrown <neilb@suse.de>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
In-Reply-To: <1310735821-sup-2589@shiny>
Message-ID: <alpine.DEB.2.02.1107150920180.3745@asgard.lang.hm>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com>
 <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011, Chris Mason wrote:

> Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
>> On 07/15/2011 12:34 PM, Chris Mason wrote:
>
> By bubble up I mean that if you have multiple layers capable of doing
> retries, the lowest levels would retry first.  Basically by the time we
> get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> do to help.

the problem with doing this is that it can end up stalling the box for 
significant amounts of time while all the retries happen.

we already see this happening today where a disk read failure is retried 
multiple times by the disk, multiple times by the raid controller, and 
then multiple times by Linux, resulting is multi-minute stalls when you 
hit a disk error in some cases.

having the lower layers do the retries automatically runs the risk of 
making this even worse.

This needs to be able to be throttled by some layer that can see the 
entire picture (either by cutting off the retries after a number, after 
some time, or by spacing out the retries to allow other queries to get in 
and let the box do useful work in the meantime)

David Lang

