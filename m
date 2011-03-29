Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1C2OnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:43:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61944 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1C2OnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:43:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Tue, 29 Mar 2011 16:42:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
References: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn>
In-Reply-To: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103291642.49555.arnd@arndb.de>
X-Provags-ID: V02:K0:+Ye9uqUTPePb6Mc35PYLb4shkbLZ4y5iwpMG2yFT1X2
 T9Aj31y/kBeFm/RmtVzECejIBfbqbAl8jCXZwxn1gaA7wZ6mgj
 p1YSRhiTPG1M7P101eSW2OO4bUF6LipJQ2PyWjZSjFCYzU6K98
 0Z2QIikMfQ4oj+gH4CHwnH+UcyuCYogmgSND7njG6p00+20uO1
 8TkbR5/JLyGdMbK0xrpqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 March 2011, Guan Xuetao wrote:
> 
> 1. make videomemory kmalloc-ed in fb-puv3.c
> 2. remove resource reservation for old fixed UNIGFX_MMAP & UVC_MMAP space
> 3. remove unused PKUNTIY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE,
>         PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE and KUSER_UNIGFX_BASE
> 4. remove unused header linux/vmalloc.h in fb-puv3.c
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

How does this work? UNIFB_MEMSIZE seems to be 4 MB, much more than the
maximum of 128 KB that kmalloc can allocate.

Shouldn't this use get_free_pages() instead of kmalloc?

	Arnd
