Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1BVOQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:16:52 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43555 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BVOQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:16:49 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        "'Greg KH'" <greg@kroah.com>
References: <02ed01cbcb48$3e3781a0$baa684e0$@mprc.pku.edu.cn> <201102171828.15482.arnd@arndb.de>
In-Reply-To: <201102171828.15482.arnd@arndb.de>
Subject: RE: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
Date: Tue, 22 Feb 2011 22:16:40 +0800
Message-ID: <018a01cbd29b$1ff4c590$5fde50b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQFzBjIBRnYbotNL7Xe3f7gpXcNfFQFYVyKIlLRmbUA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Friday, February 18, 2011 1:28 AM
> To: Guan Xuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; 'Greg KH'
> Subject: Re: [PATCHv2 06/11] unicore32 core architecture: mm related: generic codes
> 
> On Sunday 13 February 2011, Guan Xuetao wrote:
> > This patch includes generic codes for memory management.
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> > +#ifdef __io
> > +void __iomem *ioport_map(unsigned long port, unsigned int nr)
> > +{
> > +       /* we map PC lagcy 64K IO port to PCI IO space 0x80030000 */
> > +       return (void __iomem *) (unsigned long)
> > +                       io_p2v((port & 0xffff) + PKUNITY_PCILIO_BASE);
> > +}
> 
> Interestingly, this function looks completely correct, but I don't see
> the definition for __io, so I suspect that the function is not actually
> getting used.
When I want to use pci device driver,  I will define __io and use ioport_map for drivers.
It is obviously a trick. And with your patch for asm-generic/io.h, these codes could be removed.

> 
> Best make this unconditional. The code is obviously derived from the
> ARM version, which uses a macro called __io, but you don't need this
> macro because you only support one SoC platform.
> 
> 	Arnd

Thanks & Regards.
Guan Xuetao

