Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1LMDfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 22:35:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab1LMDfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 22:35:03 -0500
Message-ID: <4EE6C7AD.3020907@cn.fujitsu.com>
Date: Tue, 13 Dec 2011 11:34:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Kamal Mostafa <kamal@canonical.com>
CC: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2 4/7] VFS: Rename and refactor writeback_inodes_sb_if_idle
References: <1323367477-21685-1-git-send-email-kamal@canonical.com> <1323367477-21685-5-git-send-email-kamal@canonical.com>
In-Reply-To: <1323367477-21685-5-git-send-email-kamal@canonical.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-13 11:34:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-12-13 11:34:28,
	Serialize complete at 2011-12-13 11:34:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On thu, 8 Dec 2011 10:04:34 -0800, Kamal Mostafa wrote:
>  /**
> - * writeback_inodes_sb_if_idle	-	start writeback if none underway
> + * try_to_writeback_inodes_sb_nr	-	start writeback if none underway
>   * @sb: the superblock
>   * @nr: the number of pages to write
>   *
>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>   * Returns 1 if writeback was started, 0 if not.
>   */
> -int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
> +int try_to_writeback_inodes_sb_nr(struct super_block *sb,
>  				   unsigned long nr,
>  				   enum wb_reason reason)
>  {
>  	if (!writeback_in_progress(sb->s_bdi)) {
>  		down_read(&sb->s_umount);
> -		writeback_inodes_sb_nr(sb, nr, reason);
> +		if (nr == 0)
> +			writeback_inodes_sb(sb, reason);
> +		else
> +			writeback_inodes_sb_nr(sb, nr, reason);
>  		up_read(&sb->s_umount);
>  		return 1;
>  	} else
>  		return 0;

The comment said "Returns 1 if writeback was started", so if writeback_in_progress()
return true, I think this function also should return 1.

BTW: Does anyone know when this patchset will be merged into the main tree?

Thanks
Miao
