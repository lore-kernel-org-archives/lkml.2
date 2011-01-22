Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1AVOKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 09:10:34 -0500
Received: from sh.osrg.net ([192.16.179.4]:49338 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab1AVOKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:10:32 -0500
Date: Sat, 22 Jan 2011 23:09:56 +0900 (JST)
Message-Id: <20110122.230956.176521815.ryusuke@osrg.net>
To: wakko@animx.eu.org
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NILFS crash on 2.6.37
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20110122015748.GA3174@animx.eu.org>
References: <20110121.163738.135792151.ryusuke@osrg.net>
	<20110121.181859.144825828.ryusuke@osrg.net>
	<20110122015748.GA3174@animx.eu.org>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 22 Jan 2011 23:09:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011 20:57:48 -0500, Wakko Warner wrote:
> Ryusuke Konishi wrote:
> > On Fri, 21 Jan 2011 16:37:38 +0900 (JST), Ryusuke Konishi wrote:
> > > (Cc'ed to linux-nilfs)
> > Does the following patch fix your problem?
> 
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 0994f6a7..58fd707 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -704,7 +704,8 @@ skip_mount_setup:
> >  	sbp[0]->s_state =
> >  		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
> >  	/* synchronize sbp[1] with sbp[0] */
> > -	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> > +	if (sbp[1])
> > +		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> >  	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
> >  }
> 
> That patch fix it.  Just a note, the 2.6.37 vanilla source was about 20
> lines up from 704

Thanks for testing.  Will send upstream and to stable.


> > > > [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> > > > [ 1202.582093] NILFS warning: broken superblock. using spare superblock.
> 
> Why does it say this 2 times?  Just curious.

Because each super block is read twice in different block sizes.

Well, indeed it looks confusing.  I'll try to do something.


Ryusuke Konishi
