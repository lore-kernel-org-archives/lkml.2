Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab1BIWBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:01:52 -0500
Received: from mailfw02.zoner.fi ([84.34.147.249]:41186 "EHLO
	mailfw02.zoner.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab1BIWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:01:49 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
Date: Thu, 10 Feb 2011 00:01:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37-ARCH; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20110209195258.GN11874@hexapodia.org>
In-Reply-To: <20110209195258.GN11874@hexapodia.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102100001.42769.lasse.collin@tukaani.org>
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-09 Andy Isaacson wrote:
> % make -j4
> ...
>   CC      arch/x86/boot/tty.o
>   CC      arch/x86/oprofile/oprofile.mod.o
>   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
> exec: 23: xz: not found

This may have something to do with the shell that "make" uses to run the 
commands. The compression command isn't seen as failed with dash for 
some reason.

It doesn't matter what shell is used to run xz_wrap.sh. The same problem 
exists with other compressors if they are missing.

> commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d
[...]
> % ls -l arch/x86/boot/bzImage
> -rw-r--r-- 1 adi adi 1991504 Feb  1 18:41 arch/x86/boot/bzImage

"Feb 1" was about a week ago. The file is a few days older than the 
commit ID, assuming that your clock is set correctly.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
