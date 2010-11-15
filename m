Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab0KOJrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:47:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0KOJrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:47:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long for 32-bit ptes
Date: Mon, 15 Nov 2010 10:47:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <20101114151445.GB10871@n2100.arm.linux.org.uk> <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
In-Reply-To: <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151047.37103.arnd@arndb.de>
X-Provags-ID: V02:K0:fr+4rg82gla6jTvQhDasWW0iYqm62718Tmzare13Hwi
 JRGJdx547P5DPUEY20k7reFKRpnWbRU4zQ2Uf9rJmCJ6wLFbPl
 6KigILRcWHuydxdIV8qiYgsyb2d4nnOrckqj1yzenR1rV2oOHC
 /CkuoZ0hObNWWlOmveuwh9a+YjJaXvooSNM7niYiMc4ekoQI5I
 1fkrtdVtRTWqcYYjvplPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 November 2010 10:39:30 Catalin Marinas wrote:
> > There will be compiler warnings because u32 is unsigned int, and we
> > print it as %08lx.  Generic code cases pte values to (long long) and
> > prints them using %08llx.  We should do the same.
> 
> We still need some kind of macro because with LPAE we need %016llx
> since the phys address can go to 40-bit and there are some additional
> bits in the top word. Unless you'd like to always print 16 characters
> even for 32-bit ptes (or if there is some other printk magic I'm not
> aware of).

Why not just %010llx? That would just be two extra characters.

	Arnd
