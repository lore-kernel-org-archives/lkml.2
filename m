Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab1C3IoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 04:44:15 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:51811 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab1C3IoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 04:44:14 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Paul Mundt'" <lethal@linux-sh.org>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
References: <019701cbee1e$c4e2d260$4ea87720$@mprc.pku.edu.cn> <201103291642.49555.arnd@arndb.de> <01ca01cbee7b$4f790370$ee6b0a50$@mprc.pku.edu.cn> <201103300854.05366.arnd@arndb.de>
In-Reply-To: <201103300854.05366.arnd@arndb.de>
Subject: RE: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
Date: Wed, 30 Mar 2011 16:43:52 +0800
Message-ID: <01ea01cbeeb6$99bb5240$cd31f6c0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIFvKgm+ycIK6IzhVqIuzAjQEIKYgHgnBR1AiHIzrkBGMzJqZOpGWMw
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 30, 2011 2:54 PM
> To: Guan Xuetao
> Cc: 'Paul Mundt'; linux-kernel@vger.kernel.org; linux-fbdev@vger.kernel.org
> Subject: Re: [PATCH] unicore32 framebuffer driver fix: make videomemory kmalloc-ed and floatable
> 
> On Wednesday 30 March 2011 03:39:26 Guan Xuetao wrote:
> > > How does this work? UNIFB_MEMSIZE seems to be 4 MB, much more than the
> > > maximum of 128 KB that kmalloc can allocate.
> > >
> > > Shouldn't this use get_free_pages() instead of kmalloc?
> > >
> >
> > When using SLUB allocator, if required memory size  is larger
> > than 2*PAGE_SIZE, kmalloc_large is called,
> > and eventually __get_free_pages will  be called.
> > So,  it would be the same as __get_free_pages.
> 
> Ok, I see. It's probably still better to use __get_free_pages directly,
> because it's possible to select a different allocator that does not
> do this itself.
> 
> 	Arnd
Is it appropriate to using __get_free_pages in framebuffer driver?
And both SLAB and SLUB allocators support 4MB request.

Thanks & Regards.

Guan Xuetao


