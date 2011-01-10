Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1AJN6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:58:12 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:40432 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1AJN6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:58:10 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <024501cbaf37$4e479fd0$ead6df70$@mprc.pku.edu.cn> <201101090128.25371.arnd@arndb.de>
In-Reply-To: <201101090128.25371.arnd@arndb.de>
Subject: RE: [PATCH] asm-generic headers: modify stat.h in include/asm-generic to be applicable to more architectures
Date: Mon, 10 Jan 2011 21:58:02 +0800
Message-ID: <005201cbb0ce$65e725f0$31b571d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHcrptIjxS/TXKdAV/Q702tjnnsngH7oe//k5hfWRA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO, asm-generic headers should be used in more architectures as far as possible.
The patch of stat.h could be split into two parts to discuss.
Firstly,  STAT64_HAS_BROKEN_ST_INO is defined in most architecture's asm/stat.h,
and it should be considered as the part in asm-generic/stat.h.
Secondly, STAT64_PAD_BEFORE_* are misunderstanding definitions, and perhaps
it should use STAT64_ST_SIZE_NEED_ALIGN_64.
Indeed, the macros are used for compatibility, but most architectures could make full use of
asm-generic headers, and new architectures could just follow the default values.

Guan Xuetao

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Sunday, January 09, 2011 8:28 AM
> To: Guan Xuetao
> Cc: linux-arch@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] asm-generic headers: modify stat.h in include/asm-generic to be applicable to more architectures
> 
> On Saturday 08 January 2011, Guan Xuetao wrote:
> > From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
> >
> >  This patch modifies stat.h in include/asm-generic to be applicable to more architectures.
> >  STAT64_HAS_BROKEN_ST_INO is defined in most architecture's asm/stat.h, and it need
> >  32-bit __st_ino member to be defined in different position of 64-bit st_ino member.
> >  STAT64_PAD_BEFORE_ST_SIZE is the pad before st_size member, with default value 8 bytes.
> >  STAT64_PAD_BEFORE_ST_BLOCKS is the pad before st_blocks member, with default value
> >  4 bytes to align the following member to 64-bit.
> 
> I'd prefer not to apply this patch. It makes the generic header
> significantly more complex, and I can't see a significant benefit.
> 
> The existing architectures would all still have to define the macros
> you test and also keep defining stuff like __old_kernel_stat, while
> risking to introduce bugs while changing to the common header. We've
> done similar tricks in other places, where the differences between
> architectures are smaller, but this one doesn't seem worth it
> unless we can get to the point where we can define struct stat in
> linux/stat.h for everyone and only do the macros for the architectures
> that need it.
> 
> 	Arnd

