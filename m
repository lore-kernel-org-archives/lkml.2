Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2FDNWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:22:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:41382 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab2FDNWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:22:53 -0400
Date: Mon, 4 Jun 2012 15:22:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Avi Kivity <avi@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI
 interrupts
In-Reply-To: <4FCCB531.4000008@siemens.com>
Message-ID: <alpine.LFD.2.02.1206041519430.3086@ionos>
References: <20120601161521.26935.25606.stgit@bling.home>   <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>  <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com> <4FCB2359.9020505@redhat.com>
 <alpine.LFD.2.02.1206041235540.3086@ionos> <4FCC9EAC.9090007@siemens.com> <alpine.LFD.2.02.1206041458490.3086@ionos> <4FCCB531.4000008@siemens.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Jan Kiszka wrote:

> On 2012-06-04 15:07, Thomas Gleixner wrote:
> > On Mon, 4 Jun 2012, Jan Kiszka wrote:
> >> On 2012-06-04 13:21, Thomas Gleixner wrote:
> >> So this shortcut requires some checks before being applied to a specific
> >> MSI/MSI-X vector.
> >>
> >>
> >> Taking KVM aside, my general question remains if threaded MSI handlers
> >> of all devices really need to apply IRQF_ONESHOT though they should have
> >> no use for it.
> > 
> > In theory no, but we had more than one incident, where threaded irqs
> > w/o a primary handler and w/o IRQF_ONEHSOT lead to full system
> > starvation. Linus requested this sanity check and I think it's sane
> > and required.
> 
> OK.
> 
> > 
> > In fact it's a non issue for MSI. MSI uses handle_edge_irq which does
> > not mask the interrupt. IRQF_ONESHOT is a noop for that flow handler.
> 
> Isn't irq_finalize_oneshot processes for all flows?

Right, forgot about that. The only way we can avoid that, is that we
get a hint from the underlying irq chip/ handler setup with an extra
flag to tell the core, that it's safe to avoid the ONESHOT/finalize
magic.

Thanks,

	tglx
