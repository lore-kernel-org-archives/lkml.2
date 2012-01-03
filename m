Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab2ACJb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 04:31:28 -0500
Received: from 8bytes.org ([88.198.83.132]:53633 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2ACJbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 04:31:25 -0500
Date: Tue, 3 Jan 2012 10:31:23 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Yang Bai <hamo.by@gmail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Russell King <linux@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: Fix linux-next compile error in
	arch/arm/common/gic.c
Message-ID: <20120103093123.GA7620@8bytes.org>
References: <1325521990-4445-1-git-send-email-joerg.roedel@amd.com> <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO_0yfOzVCK8OGL5G9Aej+V4AZ12EMFKi3HafAX0JzeW9C3FtQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 08:44:01AM +0800, Yang Bai wrote:
> On Tue, Jan 3, 2012 at 12:33 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:

> >                for_each_possible_cpu(cpu) {
> > -                       unsigned long offset = percpu_offset * cpu_logical_map(cpu);
> > +                       unsigned long offset = percpu_offset;
> > +#ifdef CONFIG_SMP
> > +                       offset *= cpu_logical_map(cpu);
> > +#endif
> >                        *per_cpu_ptr(gic->dist_base.percpu_base, cpu) = dist_base + offset;
> >                        *per_cpu_ptr(gic->cpu_base.percpu_base, cpu) = cpu_base + offset;
> >                }
> > --
> > 1.7.5.4
> >
> >
> 
> Is this the right way to fix it? Or shall we do like this:
> 
> #ifdef CONFIG_SMP
> ...
> #else
> #define cpu_logical_map() 1
> #endif
> 
> and leave the gic.c code unchanged.

Well, I don't care ;) But everywhere else in this file the use of
cpu_logical_map() is #ifdef'ed with CONFIG_SMP. So for consistency my
proposed variant is better, no?


	Joerg

