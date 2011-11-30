Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab1K3Qgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:36:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab1K3Qgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:36:42 -0500
Date: Wed, 30 Nov 2011 11:36:11 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Alasdair G Kergon <agk@redhat.com>
cc: Jan Kara <jack@suse.cz>, esandeen@redhat.com, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        Valerie Aurora <val@vaaconsulting.com>
Subject: Re: [dm-devel] [PATCH] deadlock with suspend and quotas
In-Reply-To: <20111130134834.GW7595@agk-dp.fab.redhat.com>
Message-ID: <Pine.LNX.4.64.1111301134450.5759@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20111128150400.GE6366@quack.suse.cz> <CAD-XujnH1UJXrEbYAKOSjvdwVnehj4_owuduhjR0RCUBqfrg0w@mail.gmail.com>
 <Pine.LNX.4.64.1111281612030.11895@hs20-bc2-1.build.redhat.com>
 <Pine.LNX.4.64.1111281754120.11895@hs20-bc2-1.build.redhat.com>
 <20111129101901.GA5635@quack.suse.cz> <20111130133332.GV7595@agk-dp.fab.redhat.com>
 <20111130134834.GW7595@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011, Alasdair G Kergon wrote:

> On Wed, Nov 30, 2011 at 01:33:32PM +0000, Alasdair G Kergon wrote:
> > Have I missed something in this
> > reasoning, Mikulas?
>  
> Ah - counter-example: mmap?
> So sync might indeed be required to block on the filesystem iff there
> are newly-dirtied pages.
> 
> Alasdair

On non-journaled filesystem, both write and mmap can create dirty pages 
when suspended.

On ext4 I actually tested mmap, but it blocks any writes to mmaped pages 
while suspended.

Mikulas
