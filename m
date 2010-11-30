Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0K3P0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:26:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab0K3P0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:26:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Tue, 30 Nov 2010 16:26:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn> <201011291735.19556.arnd@arndb.de> <009b01cb9079$6605cd90$321168b0$@mprc.pku.edu.cn>
In-Reply-To: <009b01cb9079$6605cd90$321168b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011301626.42547.arnd@arndb.de>
X-Provags-ID: V02:K0:1gv2IPqKo78vmvzNxb173Glc18mtIHc2/wrr9XoCL7D
 4IuusCcFRamkoGmyREVxegb5bCAgeF88a11bpr216IICQOGa9O
 tUFIZRSJJceg3ay+coc+23eVXwFjrLznDsFESoaLvByjQyTkSc
 Qn2Vd3cdrocoWMCfnNz8vh6pih5CTKp38GLPFgZf91sYsYp4Ln
 QFNqO0XRCnW49ymKcHTDQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 November 2010, Guan Xuetao wrote:
> > On Saturday 27 November 2010, Guan Xuetao wrote:
> > > >
> > > > In what way does the architecture enforce this? What are the
> > > > contents of this page? Can you make it an actual VDSO rather than a
> > > > magic page that sits in the user address space?
> > > Page table is created for vector page and exceptions entry stub.
> > > However, vector page is not in the user address space.
> > 
> > Interesting. So if it's not mapped into user space, why do you even need to
> > have the vectors at a specific page? I think ARM only maps it to the high page
> > because that page is shared to user space, while most architectures just have
> > their interrupt vectors in the linar mapping, since the hardware typically uses
> > the physical address to find it.
> 
> In UniCore-32, when MMU enabled, vector page address is virtual address.

Ok. I see.

The arch_exit_mmap() and arch_setup_additional_pages() functions seems to refer to
how ARM maps this page into user space as well, you should probably change that.

I've finished the second half of the code review now, I'll follow up with an
email but drop the personal Cc to everyone besides us, in case people are getting
bored from the discussion by now ;-)

	Arnd
