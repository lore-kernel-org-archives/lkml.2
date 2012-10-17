Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2JQMWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:22:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2JQMWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:22:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 12:22:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <1350423780.1958.86.camel@kjgkr> <021601cdac19$ac462350$04d269f0$%kim@samsung.com>
In-Reply-To: <021601cdac19$ac462350$04d269f0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210171222.13614.arnd@arndb.de>
X-Provags-ID: V02:K0:8S+807AUp6m1zrp6sIoq4dGAcUQ7ogTdIKV8qq1qK2p
 hFaZ9ANW2qYNRxB8vi71LZnj4I5U1td9Eoc6VjBfPPQbZoxz8w
 JqN543F0QfKtQ9VF5+R47jNDWO6j216o3FH2K8mK36KRLK7H5m
 Iy8X7/57AdgG+rCyViZCK+e7L+3ZpqVzNTSyoCEyYeDZcn6/qa
 R+jU/q4W2MAylLIG3zbzdh/HB5TXYo1l/DtLpU+HMt7Lstefp5
 3HCwPWaEwKTALFfy8W8lSeykJwTd3Buz0d0rqfD8/5sciGmEJo
 KWm64b5HiDkEuBle7v084q3NWpqdYQRqPaVMiMeD0NsvwZVZt4
 U/f46hUZT7gHsjKdiWtk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2012, Jaegeuk Kim wrote:
> As discussed with Dave, I propose the following items.
> 
> [In v2]
> - Extension list
>    : Mkfs supports configuring extensions by user, and that information
>      will be stored in the superblock.
>      I'll add a mount option to enable/disable using the extension list.
>      Instead, f2fs supports xattr to give a hint to any files.
>      After supporting this by VFS, it'll be removed.
> - The number of active logs
>   : For compatibility, on-disk layout supports max 16 logs.
>     Instead, f2fs supports configuring the number of active logs that
>     will be used by a mount option.
>     The option supports 2, 4, and 6 logs.
> - Section size
>   : Mkfs supports multiples of segments for a section, not power-of-two.
> 
> [Future optimization]
> - Data separation
>   : file access pattern
>   : Investigate the option to make large files erase block indirect rather than
>    part of the normal logs
>   : sub-page write avoidance

Ok, sounds good! I'll comment separately on the xattr optimization,
since I had some ideas on how to combine this with other optimizations.

	Arnd
