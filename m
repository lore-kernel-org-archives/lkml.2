Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0KERXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:23:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33911 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab0KERXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:23:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kJJ6bRRO/WNgPkaaITPs/+3mMKWrj48UWaiz1IDQGvvl9geASJu4bZ16PV/u/UsbIK
         kGq4gMPWpNDLVlB/DOqXeSoJ/N8ER6jEHP4kTMcOqi+JhEGp+x/u/IAdY8htMtugOK60
         gSEwuLaOdVyBIEYgxeRwR48/8KfZ+CmfQOBVU=
Subject: Re: [PATCH v2] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.DEB.2.00.1011051153110.8161@router.home>
References: <1288892908.2659.175.camel@edumazet-laptop>
	 <1288973210.2882.733.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011051153110.8161@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 18:16:43 +0100
Message-ID: <1288977403.2882.928.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 11:54 -0500, Christoph Lameter a écrit :
> On Fri, 5 Nov 2010, Eric Dumazet wrote:
> 
> >  static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
> >  					    struct irq_desc *desc)
> 
> desc is not used.
> 
> >  {
> > -	kstat_this_cpu.irqs[irq]++;
> > -	kstat_this_cpu.irqs_sum++;
> > +	__this_cpu_inc(kstat.irqs[irq]);
> > +	__this_cpu_inc(kstat.irqs_sum);
> >  }
> 

Thats right, but it is used in CONFIG_GENERIC_HARDIRQS case.

Prototype of this function is generic, I did not change this.

(I left the macro in CONFIG_GENERIC_HARDIRQS case too because I felt
using a function could break some arches)



