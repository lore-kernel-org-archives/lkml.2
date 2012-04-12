Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762189Ab2DLLuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:50:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab2DLLuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:50:03 -0400
Date: Thu, 12 Apr 2012 14:49:55 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: dont clear TMR on EOI
Message-ID: <20120412114955.GI20431@redhat.com>
References: <20120411154953.GA24008@redhat.com>
 <20120412020318.GA3037@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412020318.GA3037@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:03:18PM -0300, Marcelo Tosatti wrote:
> On Wed, Apr 11, 2012 at 06:49:55PM +0300, Michael S. Tsirkin wrote:
> > Intel spec says that TMR needs to be set/cleared
> > when IRR is set, but kvm also clears it on  EOI.
> > 
> > I did some tests on a real (AMD based) system,
> > and I see same TMR values both before
> > and after EOI, so I think it's a minor bug in kvm.
> > 
> > This patch fixes TMR to be set/cleared on IRR set
> > only as per spec.
> > 
> > And now that we don't clear TMR, we can save
> > an atomic read of TMR on EOI that's not propagated
> > to ioapic, by checking whether ioapic needs
> > a specific vector first and calculating
> > the mode afterwards.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/x86/kvm/lapic.c |   19 +++++++++++++------
> >  virt/kvm/ioapic.c    |   10 +++++++---
> >  virt/kvm/ioapic.h    |    1 +
> >  3 files changed, 21 insertions(+), 9 deletions(-)
> 
> Looks OK, ioapic_service -> accept_apic_irq will set TMR 
> again if IRR is raised. Gleb, can you review please?
> 
Looks good to me.

--
			Gleb.
