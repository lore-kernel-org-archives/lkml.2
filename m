Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab0LAMzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:55:23 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:50606 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab0LAMzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:55:21 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
References: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn> <201011291735.19556.arnd@arndb.de> <009b01cb9079$6605cd90$321168b0$@mprc.pku.edu.cn> <201011301626.42547.arnd@arndb.de>
In-Reply-To: <201011301626.42547.arnd@arndb.de>
Subject: RE: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Wed, 1 Dec 2010 20:54:59 +0800
Message-ID: <00ef01cb9156$fd21d920$f7658b60$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGzHwPsQ4MuY7Ev2RR1f0Fo5aRFLgHaGlRQARhXLX4CFVtVjJOUMJJg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, November 30, 2010 11:27 PM
> To: Guan Xuetao
> Cc: 'Greg KH'; 'Andrew Morton'; 'Linus Torvalds'; linux-
> kernel@vger.kernel.org; linux-arch@vger.kernel.org
> Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-
> 2.6.37-rc1
> 
> On Tuesday 30 November 2010, Guan Xuetao wrote:
> > > On Saturday 27 November 2010, Guan Xuetao wrote:
> > > > >
> > > > > In what way does the architecture enforce this? What are the
> > > > > contents of this page? Can you make it an actual VDSO rather
> > > > > than a magic page that sits in the user address space?
> > > > Page table is created for vector page and exceptions entry stub.
> > > > However, vector page is not in the user address space.
> > >
> > > Interesting. So if it's not mapped into user space, why do you even
> > > need to have the vectors at a specific page? I think ARM only maps
> > > it to the high page because that page is shared to user space, while
> > > most architectures just have their interrupt vectors in the linar
> > > mapping, since the hardware typically uses the physical address to
find it.
> >
> > In UniCore-32, when MMU enabled, vector page address is virtual address.
> 
> Ok. I see.
> 
> The arch_exit_mmap() and arch_setup_additional_pages() functions seems
> to refer to how ARM maps this page into user space as well, you should
> probably change that.
Vector page is also used as kuser page, so arch_setup_additional_pages need
to 
Map it into user space.

> 
> I've finished the second half of the code review now, I'll follow up with
an
> email but drop the personal Cc to everyone besides us, in case people are
> getting bored from the discussion by now ;-)
Thanks again.

Guan Xuetao

