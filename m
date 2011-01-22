Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab1AVB5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:57:55 -0500
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:46075 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1AVB5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:57:54 -0500
Date: Fri, 21 Jan 2011 20:57:48 -0500
From: Wakko Warner <wakko@animx.eu.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NILFS crash on 2.6.37
Message-ID: <20110122015748.GA3174@animx.eu.org>
Mail-Followup-To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
	linux-nilfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110121024918.GA29598@animx.eu.org> <20110121.163738.135792151.ryusuke@osrg.net> <20110121.181859.144825828.ryusuke@osrg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121.181859.144825828.ryusuke@osrg.net>
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi wrote:
> On Fri, 21 Jan 2011 16:37:38 +0900 (JST), Ryusuke Konishi wrote:
> > (Cc'ed to linux-nilfs)
> > > [ 1202.581501] NILFS warning: broken superblock. using spare superblock.
> > > [ 1202.582093] NILFS warning: broken superblock. using spare superblock.

Why does it say this 2 times?  Just curious.

> > Thanks for the report.
> > 
> > This seems to be a regression on 2.6.36 which could happen when one of
> > two superblocks is broken.
> > 
> > I'll fix it.
> 
> Does the following patch fix your problem?

> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index 0994f6a7..58fd707 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -704,7 +704,8 @@ skip_mount_setup:
>  	sbp[0]->s_state =
>  		cpu_to_le16(le16_to_cpu(sbp[0]->s_state) & ~NILFS_VALID_FS);
>  	/* synchronize sbp[1] with sbp[0] */
> -	memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
> +	if (sbp[1])
> +		memcpy(sbp[1], sbp[0], nilfs->ns_sbsize);
>  	return nilfs_commit_super(sbi, NILFS_SB_COMMIT_ALL);
>  }

That patch fix it.  Just a note, the 2.6.37 vanilla source was about 20
lines up from 704

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
