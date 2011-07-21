Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1GUWK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 18:10:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab1GUWKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 18:10:53 -0400
Date: Fri, 22 Jul 2011 08:10:40 +1000
From: NeilBrown <neilb@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jonathan Brassow <jbrassow@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-raid@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com
Subject: Re: linux-next: Tree for July 21 (drivers/md/dm-raid)
Message-ID: <20110722081040.48abfff1@notabene.brown>
In-Reply-To: <20110721145648.2477f8bb.rdunlap@xenotime.net>
References: <20110721165542.7748c88a1d1e0b228c7fe3fa@canb.auug.org.au>
	<20110721145648.2477f8bb.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 14:56:48 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:

> On Thu, 21 Jul 2011 16:55:42 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> When CONFIG_DM_RAID=m and CONFIG_MD_RAID1 is not enabled:
> 
> ERROR: "md_raid1_congested" [drivers/md/dm-raid.ko] undefined!
> 
> due to:
> 
> 	if (rs->raid_type->level == 1)
> 		return md_raid1_congested(&rs->md, bits);
> 
> Should that just be surrounded with this?
> 
> #if defined(CONFIG_MD_RAID1) || defined(CONFIG_MD_RAID1_MODULE)
> ...
> #endif
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


I suspect the right thing to do is add
   select MD_RAID1
to the 
   config DM_RAID

stanza.  What do you think Jon?

NeilBrown
