Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1APPiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:38:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1APPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:38:17 -0500
Message-ID: <4D3310E3.9020909@redhat.com>
Date: Sun, 16 Jan 2011 17:38:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] perf-kvm support for SVM
References: <1295019902-31339-1-git-send-email-joerg.roedel@amd.com> <4D32CD45.3090503@redhat.com> <20110116153506.GI6376@8bytes.org>
In-Reply-To: <20110116153506.GI6376@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2011 05:35 PM, Joerg Roedel wrote:
> On Sun, Jan 16, 2011 at 12:49:41PM +0200, Avi Kivity wrote:
> >  On 01/14/2011 05:45 PM, Joerg Roedel wrote:
>
> >>  here is the reworked version of the patch-set. Only patch 1/2 has
> >>  changed and now contains the real fix for the crashes that were seen and
> >>  has an updated log message.
> >>
> >
> >  Thanks, applied.  2.6.37 and earlier aren't affected, yes?  So I'm
> >  queuing it for 2.6.38 only.
>
> I think the problem is there since KVM has lazy state switching. So the
> fix in patch 1 should make it in all currently maintained stable-trees.
>

The problem is with load_gs_index(), yes?  In 2.6.37 this is called 
before stgi(), so it's protected from nmi.

-- 
error compiling committee.c: too many arguments to function

