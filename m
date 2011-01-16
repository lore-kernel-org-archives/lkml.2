Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1APXTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:19:55 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58542 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1APXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:19:52 -0500
Subject: Re: [PATCH] target: Fix memory leak in
	fd_set_configfs_dev_params().
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1101162357250.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162006410.13377@swampdragon.chaosbits.net>
	 <1295218456.22813.61.camel@haakon2.linux-iscsi.org>
	 <alpine.LNX.2.00.1101162357250.13377@swampdragon.chaosbits.net>
Content-Type: text/plain
Date: Sun, 16 Jan 2011 15:19:48 -0800
Message-Id: <1295219988.22813.72.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 23:59 +0100, Jesper Juhl wrote:
> On Sun, 16 Jan 2011, Nicholas A. Bellinger wrote:
> 
> > On Sun, 2011-01-16 at 20:17 +0100, Jesper Juhl wrote:
> > > match_strdup() dynamically allocates memory and it is the responsabillity 
> > > of the caller to free that memory. In 
> > > drivers/target/target_core_file.c::fd_set_configfs_dev_params() two calls 
> > > are made to match_strdup() and in neither case is the allocated memory 
> > > freed, but instead it is leaked.
> > > 
> > > This patch should take care of the problem by kfree()'ing the allocated 
> > > memory once it is no longer needed. It also makes sure to return -ENOMEM 
> > > if the memory allocation in match_strdup() should fail.
> > > 
> > > Please review and consider for inclusion.
> > > 
> > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > 
> > Ugh, this was my fault during the recent v4.0 configfs parameter
> > conversion.  Committed as 5c45b37 in lio-core-2.6.git/linus-38-rc1 and I
> > will fix up the other handful of match_strdup() breakage and carry into
> > scsi-post-merge-2.6.git/for-jejb shortly.
> > 
> > Thanks for catching this..
> > 
> 
> You're welcome.
> Yes, I did see a bunch of other match_strdup() related problems, but I 
> thought I'd just fix up one file initially to see the general reaction, 
> then do the rest later when this one had been merged. but if you want to 
> fix up the remainder, feel free.
> 
> I guess we can merge this patch as a starting point?
> 

Sure, the other two follow-up match_strdup() memory leak bugfix patches
for target/iblock and target_core_configfs.c APTPL metadata token
parsing have been included into the scsi-post-merge-2.6.git/for-jejb
queue.

Thanks again!

--nab

