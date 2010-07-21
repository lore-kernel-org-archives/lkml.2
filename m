Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739Ab0GUInr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 04:43:47 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39522 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415Ab0GUInq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 04:43:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rzB1bUWMpamvbyk2Sc9gejEMoBUrQx/zUIpZf4qzvVbTZc3lGCnszGY5DzcrZTEEAr
         V96fyjW2IkChabG7b2EZaVE9g3ibX60J+PWypPVj4ff1URMh52IypEDxGOxs4YrYuiHx
         PYVIXo5UyDB2HWXQ/gUhGvTeZOLbyX/0V8JyY=
MIME-Version: 1.0
In-Reply-To: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
References: <AANLkTilYEJMD_s5Iupru24WPXasxI_jE8JVJ35Nf8hrN@mail.gmail.com>
Date: Wed, 21 Jul 2010 09:43:43 +0100
Message-ID: <AANLkTinQKhvnAIa-1qXxIWFHCeE0ajM-07eYOAH1QA_J@mail.gmail.com>
Subject: Re: udevd / ext4 issue mounting 2.6.35-rc5
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-ext4@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luis,

On 21 July 2010 01:36, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> I have been reluctant to boot to 2.6.35-rc due to the large set of
> regression list and the amount of work I needed to actually get done
> on 2.6.35. Last I checked the regression list it was getting small so
> I gave it a spin today. No luck. I get some bootup error from udevd
> and ext2/ext3/ext4, something like this:
>
> EXT3-fs (sda1): error: couldn't mount because of unsupported optional
> features (240)
> EXT2-fs (sda1): error: couldn't mount because of unsupported optional
> features (240)
> EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)

This succeeded.

> VFS: Mounted root (ext4 filesystem) readonly on device 8:1
> Freeing unused kernel memory: 708k freed
> Write protecting the kernel read-only data: 102040k
> Freeing unused kernel memory: 764k freed
> Freeing unused kernel memory: 1796k freed
> udevd: failed to create queue file: No such file or directory
> udevd: error creating queue file

It looks like you need to enable:

CONFIG_DEVTMPFS
CONFIG_DEVTMPFS_MOUNT

> The picture:
>
> http://bombadil.infradead.org/~mcgrof/images/2010/ext4-option-240-fails-2.6.35-rc5.jpg
>
> I then decided to pull Linus' latest but it didn't help either. I
> don't recall seeing this reported on the regression list yet.
> Essentially I cannot move forward after this happens, even on single
> user boot and disabling wireless, which was my main suspect first as
> I'm using wireless-testing.git.
>
> I can certainly bisect but first wanted to see if this was already known.
>
>
> mcgrof@tux ~/wireless-testing (git::sfo-02)$ grep CONFIG_EXT .config
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> CONFIG_EXT3_FS_POSIX_ACL=y
> CONFIG_EXT3_FS_SECURITY=y
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_XATTR=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> # CONFIG_EXT4_DEBUG is not set
>
> Let me know if you need more details.
>
>  Luis
-- 
Daniel J Blueman
