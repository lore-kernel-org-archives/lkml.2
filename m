Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230Ab1IVMNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 08:13:10 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:39800 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab1IVMNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 08:13:08 -0400
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
From: "Jon Medhurst (Tixy)" <jon.medhurst@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Martin <dave.martin@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20110922115713.GJ12025@e102109-lin.cambridge.arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
	 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
	 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
	 <20110921113906.GB2872@arm.com>
	 <20110921115553.GF17169@n2100.arm.linux.org.uk>
	 <1316676488.2053.9.camel@linaro1>
	 <CAHkRjk7B4Bmt2g6ptHO3TudXgrkr5rv4b--Hbx-mw7=MO9Q+BQ@mail.gmail.com>
	 <1316689606.2053.29.camel@linaro1>
	 <20110922115713.GJ12025@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Sep 2011 13:13:01 +0100
Message-ID: <1316693581.2053.38.camel@linaro1>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 12:57 +0100, Catalin Marinas wrote:
> On Thu, Sep 22, 2011 at 12:06:46PM +0100, Jon Medhurst (Tixy) wrote:
> > On Thu, 2011-09-22 at 10:48 +0100, Catalin Marinas wrote:
> > > We could improve things a bit in the unwinder and assume
> > > that if the fault address is the same as the .fnstart address, the
> > > return value is always in LR and the SP not affected (that's unwinding
> > > bytecode 0xb0). For a few instructions into the function prologue we
> > > can't reliably get the unwinding information.
> > 
> > That would help make it possible to unwind out of kprobes handlers to
> > the probed function. The kprobes code itself would need work as well,
> > and possibly the undef handler. Do we think it is worthwhile to do
> > this? 
> 
> Does kprobes need to trace beyond the probed function? If not, you get
> the address of the probed function via pt_regs anyway, so no need for
> unwinding beyond that.

To be honest, I'm not very sure how kprobes get used in the real world.
Though, if stack unwinding from their handlers currently doesn't work
and people had a usecase for it, we would expect them to complain.

-- 
Tixy

