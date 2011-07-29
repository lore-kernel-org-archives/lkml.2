Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1G2KEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:04:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45848 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1G2KEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:04:52 -0400
Message-ID: <4E328457.2000401@gmail.com>
Date: Fri, 29 Jul 2011 11:58:47 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry maybe I'm a bit late? :)

Il 28/06/2011 17:33, Josef Bacik ha scritto:
>
>   loff_t default_llseek(struct file *file, loff_t offset, int origin)
>   {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>   	loff_t retval;
>
> -	mutex_lock(&file->f_dentry->d_inode->i_mutex);
> +	mutex_lock(&inode->i_mutex);
>   	switch (origin) {
>   		case SEEK_END:
> -			offset += i_size_read(file->f_path.dentry->d_inode);
> +			offset += i_size_read(inode);

Here we are under mutex, so I think we can use directly i_size without 
i_size_read.

Marco
