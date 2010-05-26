Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949Ab0EZDVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 23:21:55 -0400
Received: from mswedge2.sunplus.com ([124.219.29.227]:59633 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab0EZDVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 23:21:52 -0400
X-Greylist: delayed 2224 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 23:21:51 EDT
In-Reply-To: <201005251703.11613.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Ulrich Drepper <drepper@gmail.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chen Liqin <liqin.chen@sunplusct.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.3 September 26, 2007
Message-ID: <OF1161BF2B.C681A3D5-ON4825772F.000A9BAB-4825772F.000F0B04@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Wed, 26 May 2010 10:44:19 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.4|March 23, 2009) at 2010/05/26 ?? 10:44:21,
	Serialize complete at 2010/05/26 ?? 10:44:21
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4Q3Otim001214

Arnd Bergmann <arnd@arndb.de> Ğ´ÓÚ 2010-05-25 23:03:11:

> 
> > - You renamed __NR__llseek to __NR_llseek, which of course seems 
pretty
> > reasonable, but libc expects to see the former (both glibc and 
uclibc). 
> > Is it worth requiring non-standard libc code?  I may just add
> > __NR__llseek as an alias in my unistd.h for now.
> 
> That was probably just a mistake on my side. The only other
> architecture using the generic version so far is score, so
> maybe Chen Liqin can comment on how he dealt with this and
> if he depends on the definition now.
> 

When we port glibc to score arch, we fixed the llseek.c file,
remove the underscore before llseek. maybe it has compatible problems, 
but it work ok with score application.

34c34
<   return (loff_t) (INLINE_SYSCALL (_llseek, 5, fd, (off_t) (offset >> 
32),
---
>   return (loff_t) (INLINE_SYSCALL (llseek, 5, fd, (off_t) (offset >> 
32),


--
liqin

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
