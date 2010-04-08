Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab0DHCeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:34:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:50160 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0DHCeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:34:08 -0400
Date: Thu, 08 Apr 2010 11:34:05 +0900 (JST)
Message-Id: <20100408.113405.221629738.ryusuke@osrg.net>
To: lihong.hi@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] nilfs2: add a print message after loading nilfs2
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20100407142058.GA27224@xhl>
References: <20100405173402.GA22644@xhl>
	<20100405173534.GB22644@xhl>
	<20100407142058.GA27224@xhl>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 08 Apr 2010 11:34:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010 22:20:58 +0800, Li Hong <lihong.hi@gmail.com> wrote:
> Hi KONISHI Ryusuke,
> 
> Any feedbacks on these patches?
> 
> Thanks,
> Li Hong

Well, adding a load message is ok, but it should be more moderate like
"nilfs2 file system loaded\n".

I think this sort of change should be discussed in the sub topic
mailing list (i.e. linux-nilfs).  You don't have to cc every patch to
linux-kernel.

And, please include some explanation in the change log to clarify the
aim or motivation.

Thanks,
Ryusuke Konishi

> On Tue, Apr 06, 2010 at 01:35:34AM +0800, Li Hong wrote:
> > From b4e426f77cd05bd6046c1fa67c51ee06368ea23e Mon Sep 17 00:00:00 2001
> > From: Li Hong <lihong.hi@gmail.com>
> > Date: Tue, 6 Apr 2010 01:23:04 +0800
> > Subject: [PATCH] nilfs2: add a print message after loading nilfs2
> > 
> > 
> > Signed-off-by: Li Hong <lihong.hi@gmail.com>
> > ---
> >  fs/nilfs2/super.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 2e767bc..9f91765 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -1186,7 +1186,12 @@ static int __init init_nilfs_fs(void)
> >  		return err;
> >  
> >  	err = register_filesystem(&nilfs_fs_type);
> > -	return err;
> > +	if (err)
> > +		return err;
> > +
> > +	printk(KERN_INFO "nilfs2 file system loaded!\n");

	printk(KERN_INFO "nilfs2 file system loaded!\n");

> > +	return 0;
> > +
> >  }
> >  
> >  static void __exit exit_nilfs_fs(void)
> > -- 
> > 1.6.3.3
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
