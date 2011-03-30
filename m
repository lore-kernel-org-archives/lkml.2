Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1C3Bjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:39:42 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:54921 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1C3Bjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:39:41 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
References: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn> <201103291642.49555.arnd@arndb.de>
In-Reply-To: <201103291642.49555.arnd@arndb.de>
Subject: RE: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Wed, 30 Mar 2011 09:39:26 +0800
Message-ID: <01ca01cbee7b$4f790370$ee6b0a50$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIFvKgm+ycIK6IzhVqIuzAjQEIKYgHgnBR1k8J1ZwA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, March 29, 2011 10:43 PM
> To: Guan Xuetao
> Cc: Paul Mundt; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org
> Subject: Re: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
> 
> On Tuesday 29 March 2011, Guan Xuetao wrote:
> >
> > 1. make videomemory kmalloc-ed in fb-puv3.c
> > 2. remove resource reservation for old fixed UNIGFX_MMAP & UVC_MMAP space
> > 3. remove unused PKUNTIY_UNIGFX_MMAP_BASE, PKUNITY_UNIGFX_MMAP_SIZE,
> >         PKUNITY_UVC_MMAP_BASE, PKUNITY_UVC_MMAP_SIZE and KUSER_UNIGFX_BASE
> > 4. remove unused header linux/vmalloc.h in fb-puv3.c
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> How does this work? UNIFB_MEMSIZE seems to be 4 MB, much more than the
> maximum of 128 KB that kmalloc can allocate.
> 
> Shouldn't this use get_free_pages() instead of kmalloc?
> 
> 	Arnd

When using SLUB allocator, if required memory size  is larger than 2*PAGE_SIZE, kmalloc_large is called,
and eventually __get_free_pages will  be called.
So,  it would be the same as __get_free_pages.


