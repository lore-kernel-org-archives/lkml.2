Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab2JaH1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:27:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2JaH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:27:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Date: Tue, 30 Oct 2012 22:22:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com> <20121024200431.GE6713@beefymiracle.amer.corp.natinst.com> <3c9e591c-a29f-446b-9256-bb23ff6d840d@TX2EHSMHS014.ehs.local>
In-Reply-To: <3c9e591c-a29f-446b-9256-bb23ff6d840d@TX2EHSMHS014.ehs.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210302222.15656.arnd@arndb.de>
X-Provags-ID: V02:K0:rflTO5tTv/ud7SShH+bdhcIv6tPh8hl5tw3w7G7oXNI
 yAJPs2siq4X3/qCULmGRdQBUiH3nZXOdUmD0uKJJcOW2T7rUCc
 Zd3XW88cx095H+q/7wOxiczbcdXhrujg5HDIPOqf7PxeocV1uH
 Xp98Fu502dhE4GHq00HHHM/69Fw7mF+pDUipsJ0FsFzTnciaWS
 nqSvs6qmdBERcsYEsh/+N/W8VbG1tD9TZyO3P1zfhpUy/hAJ+G
 nH8kIUANdi/Y4YYSTW+6sLlDhaUR7rXeRTvt1H1AFkEDS06Dls
 eqx2MWE/IXX7DKwBnT3rRG/95DZFxWbvZvevWqNqV4OEtPLF/P
 v+yYnH4/XeJ2FaC8/Z/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 October 2012, Michal Simek wrote:
> > diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> > index 08c1231..72904a2 100644
> > --- a/arch/arm/include/asm/pgtable.h
> > +++ b/arch/arm/include/asm/pgtable.h
> > @@ -40,7 +40,7 @@
> >   */
> >  #define VMALLOC_OFFSET               (8*1024*1024)
> >  #define VMALLOC_START                (((unsigned long)high_memory +
> > VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
> > -#define VMALLOC_END          0xff000000UL
> > +#define VMALLOC_END          _AC(0xff000000,UL)
> 
> This shouldn't be the part of this series but should go to mainline through different tree.
> Arnd, Olof: Can you take this patch to your arm-soc tree? 
> 
> I don't think it is a good workstyle to propose it to mainline through zynq soc tree.
> What do you think?

The arm-soc tree is not the right place either, this is architecture code which is
in Russell's domain. I would suggest getting an Ack from Russell if he's ok with
it and then merging it together with your other changes into arm-soc.

	Arnd
