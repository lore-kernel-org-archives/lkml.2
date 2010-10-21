Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0JUDr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:47:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45797 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab0JUDr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:47:58 -0400
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=2fj8i2joSkMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1JhCslmsnvBdcnIjHfkA:9 a=o5RBp3wL4WpnBwiUH7TyFPedCskA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] tracing: Prevent unloadable modules from using
 trace_bprintk()
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20101021034255.GG5387@nowhere>
References: <20101021024233.530237054@goodmis.org>
	 <20101021024304.827826848@goodmis.org>  <20101021034255.GG5387@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Oct 2010 23:47:56 -0400
Message-ID: <1287632876.16971.561.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 05:42 +0200, Frederic Weisbecker wrote:

> > +/*
> > + * Module code must not use trace_bprintk, because if it is unloaded
> > + * then we leave a pointer back to the module code inside
> > + * the ring buffer, and then reading the ring buffer may cause a bug.
> > + *
> > + * We do allow for modules to use it if the kernel does not allow
> > + * unloading of modules, and MODVERSIONS is set (to make sure kernel
> > + * and module are the same). If you load modules without MODVERSIONS
> > + * set, then you deserve what you get.
> > + */
> > +#if defined(MODULE) &&							\
> 
> 
> 
> Did you mean CONFIG_MODULE may be?

Nope, then the a kernel that allows modules wont use it. I do mean
"MODULE", as in defined by the Makefile:

KBUILD_AFLAGS_MODULE  := -DMODULE
KBUILD_CFLAGS_MODULE  := -DMODULE

-- Steve


