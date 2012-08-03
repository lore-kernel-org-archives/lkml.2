Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2HCOwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:52:19 -0400
Received: from seven.medozas.de ([5.9.24.206]:34044 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843Ab2HCOwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:52:07 -0400
Date: Fri, 3 Aug 2012 16:52:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: "Steven J. Magnani" <steve@digidescorp.com>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
In-Reply-To: <1341314074-2867-1-git-send-email-steve@digidescorp.com>
Message-ID: <alpine.LNX.2.01.1208031650580.3676@frira.zrqbmnf.qr>
References: <1341314074-2867-1-git-send-email-steve@digidescorp.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2012-07-03 13:14, Steven J. Magnani wrote:

>Nearly identical shortname parsing is performed in fat_search_long()
>and __fat_readdir(). Extract this code into a function that may be
>called by both.
>
>v2: Attempt to clarify difference between vfat and msdos parsing.
>    Remove decision-making from fat_tolower() for clarity.
>
>Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
>---
>diff -uprN linux-3.5-rc4/fs/fat/dir.c new/fs/fat/dir.c
>--- linux-3.5-rc4/fs/fat/dir.c	2012-06-29 11:20:12.766348728 -0500
>+++ new/fs/fat/dir.c	2012-07-03 06:10:36.066283411 -0500
>@@ -35,6 +35,11 @@
> #define FAT_MAX_UNI_CHARS	((MSDOS_SLOTS - 1) * 13 + 1)
> #define FAT_MAX_UNI_SIZE	(FAT_MAX_UNI_CHARS * sizeof(wchar_t))
> 
>+static inline unsigned char fat_tolower(unsigned char c)
>+{
>+	return ((c >= 'A') && (c <= 'Z')) ? c+32 : c;
>+}
>+

The kernel already has a tolower() function, can that not be used?

