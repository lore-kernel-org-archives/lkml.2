Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1APW7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 17:59:39 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18294 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1APW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 17:59:37 -0500
Date: Sun, 16 Jan 2011 23:59:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] target: Fix memory leak in
 fd_set_configfs_dev_params().
In-Reply-To: <1295218456.22813.61.camel@haakon2.linux-iscsi.org>
Message-ID: <alpine.LNX.2.00.1101162357250.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162006410.13377@swampdragon.chaosbits.net> <1295218456.22813.61.camel@haakon2.linux-iscsi.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Jan 2011, Nicholas A. Bellinger wrote:

> On Sun, 2011-01-16 at 20:17 +0100, Jesper Juhl wrote:
> > match_strdup() dynamically allocates memory and it is the responsabillity 
> > of the caller to free that memory. In 
> > drivers/target/target_core_file.c::fd_set_configfs_dev_params() two calls 
> > are made to match_strdup() and in neither case is the allocated memory 
> > freed, but instead it is leaked.
> > 
> > This patch should take care of the problem by kfree()'ing the allocated 
> > memory once it is no longer needed. It also makes sure to return -ENOMEM 
> > if the memory allocation in match_strdup() should fail.
> > 
> > Please review and consider for inclusion.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Ugh, this was my fault during the recent v4.0 configfs parameter
> conversion.  Committed as 5c45b37 in lio-core-2.6.git/linus-38-rc1 and I
> will fix up the other handful of match_strdup() breakage and carry into
> scsi-post-merge-2.6.git/for-jejb shortly.
> 
> Thanks for catching this..
> 

You're welcome.
Yes, I did see a bunch of other match_strdup() related problems, but I 
thought I'd just fix up one file initially to see the general reaction, 
then do the rest later when this one had been merged. but if you want to 
fix up the remainder, feel free.

I guess we can merge this patch as a starting point?

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

