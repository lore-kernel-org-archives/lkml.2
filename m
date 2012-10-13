Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab2JMUwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 16:52:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab2JMUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 16:52:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Sat, 13 Oct 2012 20:52:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
In-Reply-To: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210132052.09835.arnd@arndb.de>
X-Provags-ID: V02:K0:6iNVcYq5wiDaVCxPkWOxNDDCSYYlvsr391x/Q3+s8U4
 t/fSo64MgiMRUM5CXwa9o1wwsM+K0JeuL/3eRwj3cfgRRr2BR1
 5JGyQE2OBHeBPT+at+j/tT/uEftogCW5eqLt0hVJ0dO2MMJm9Y
 Iq6uT8Zc7xMKL7YfXnKcMYGrUHuoHHqRHhv5cIjiIVW8W/lWQH
 g2znXounX7PyTAzqfWVgHq2OOCfr/tm6DqE1chmVMIV0OSq7dy
 qB4DEeOXrLnjKkyflZMCcWW8mk3v0bOPnjT7DmdphibV0RyS5F
 +bfuUUyF5Po727zP0IWtaKiVOQDyP3qYkLOuzmrokAeVW/mOm1
 qXgBlf9uOz8DyjF6r6KM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 October 2012, 김재극 wrote:
> +const char *media_ext_lists[] = {
> +       "jpg",
> +       "gif",
> +       "png",
> +       "avi",
> +       "divx",
> +       "mp4",
> +       "mp3",
> ...

> + * Set multimedia files as cold files for hot/cold data separation
> + */
> +static inline void set_cold_file(struct inode *inode, const unsigned char *name)
> +{
> +       const char **extlist = media_ext_lists;
> +
> +       while (*extlist) {
> +               if (!is_multimedia_file(name, *extlist)) {
> +                       F2FS_I(inode)->is_cold = 1;
> +                       break;
> +               }
> +               extlist++;
> +       }
> +}

This is a very clever way of categorizing files by their name, but I wonder if hardcoding
the list of file name extensions at in the kernel source is the best strategy. Generally
I would consider this to be a policy that should be configurable by the user.

Unfortunately I can't think of a good interface to configure this, but maybe someone
else has a useful idea. Maybe the list can be stored in the superblock and get written
at mkfs time from the same defaults, but with the option of overriding it using
a debugfs tool.

	Arnd
