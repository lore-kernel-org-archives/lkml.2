Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab1HJOYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:24:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:24:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: Subject: L2x0 OF properties do not include interrupt #
Date: Wed, 10 Aug 2011 16:24:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "weizeng.he@csr.com" <weizeng.he@csr.com>,
        "workgroup.linux@csr.com" <workgroup.linux@csr.com>,
        "'Barry Song'" <21cnbao@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Olof Johansson'" <olof@lixom.net>
References: <000201cc575b$c1229010$4367b030$@rutland@arm.com> <4E428EB0.1080204@gmail.com> <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110810141048.GK10121@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108101624.27881.arnd@arndb.de>
X-Provags-ID: V02:K0:zcsEpiy32AKuwPvTI8EvZNu1mzzUtnIbowfECHQY47O
 p3vF8AoDioq3NotupX70U4Cc5H/OmR+lGD1LTsebmmF04O3D3Q
 /ZbmZIIXL0TLzcdbUPO4d+ZSNIa7x2UmyzgdwcljhHMA7jrHwl
 VnZknRV/t6MoQHIPdLYxy8QVIathEVYHGostWFlPCEZoNnVMZR
 q/CdwaJp/uGQWpTUGGP4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 August 2011, Will Deacon wrote:
> On Wed, Aug 10, 2011 at 02:59:12PM +0100, Rob Herring wrote:
> > I think you should allow for either the single irq or individual irqs.
> > You can specify that the event counter interrupt must be first, then the
> > pmu driver could work either way ignoring the rest. The driver probably
> > needs to mark the handler as shared if there is only the combined
> > interrupt unless you expect all interrupts to be handled by 1 driver.
> 
> I much prefer having seperate, individual IRQs with no requirement on
> ordering.
> 

What do you mean with 'no requirement on ordering'? If we have multiple
interrupt sources, we definitely want to identify which one calls which
handler, and the only information we have is the position in the array
of interrupt numbers.

	Arnd
