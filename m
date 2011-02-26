Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1BZNQT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 08:16:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab1BZNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 08:16:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Sat, 26 Feb 2011 14:16:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102221519.03423.arnd@arndb.de> <010f01cbd5b0$09980830$1cc81890$@mprc.pku.edu.cn>
In-Reply-To: <010f01cbd5b0$09980830$1cc81890$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261416.10050.arnd@arndb.de>
X-Provags-ID: V02:K0:4ZdjKG1XcLnSh1bgvgU1CfQ+447wFYfixF6HOrf+dM4
 eFYrNm6yPZEFpe9CMelZsyjH8MUN4pO433fCorlJESGZALAgb4
 ddVgBtx/AhRXiLZUwBATFtc5HTYy+rlDIqEe7LoBhY+HoAyESG
 3+5lCLKPFHWcaHcVIKozFECcn5j2jPp/oWLe5O4c+In7jHFeFL
 cma3ugEsQIPYIycqqQJiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 February 2011, Guan Xuetao wrote:
> > >  #ifndef __ASSEMBLY__
> > >
> > > -# define __REG(x)      (*((volatile unsigned long *)io_p2v(x)))
> > > -# define __PREG(x)     (io_v2p((unsigned long)&(x)))
> > > +# define __REG(x)      (void __iomem *)io_p2v(x)
> > 
> > The patch looks correct, but if you make the the definition for
> > PKUNITY_MMIO_BASE contain the cast to (void __iomem *), you no
> > longer need another cast.
>
> Because the io_p2v(x) calculate x and PKUNITY_IOSPACE_BASE,
> all registers should be added with (void __iomem *).
> So I prefer to remain the previous patch.

The problem with the definition of io_p2v is that it gives you
an type that is impossible to use correctly, except in assembly
code. Linux assumes that MMIO registers in virtual space
are __iomem pointers, and we like that to be consistent.

If you have a function that returns a virtual address, it should
really have the same type as any other function that uses a virtual
address.

	Arnd
