Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2EUX0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:26:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42964 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2EUX0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:26:00 -0400
Date: Tue, 22 May 2012 07:26:18 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
Message-ID: <20120521232616.GF8140@S2101-09.ap.freescale.net>
References: <4FB80F32.5090309@gmail.com>
 <20120520030653.GB5810@S2100-06.ap.freescale.net>
 <4FB9A5E7.2070000@gmail.com>
 <20120521064901.GE8140@S2101-09.ap.freescale.net>
 <4FBA89E3.7010106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA89E3.7010106@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 01:30:59PM -0500, Rob Herring wrote:
> > With the bindings here, I need something like below in device tree to
> > replace the clk lookup registration that is currently done in imx6q
> > sabrelite specific setup code.  However the problem here is I have cko
> > defined in clock driver, and thus I can not give phandle to cko in
> > device tree.  What I suggest is for such cases, we could require
> > clock-names = "cko" than clocks = <&cko>, and of_clk_get() should also
> > be able to find the clock with looking for the clk name.
> > 
> > imx6q-sabrelite.dts:
> > 
> > 	codec: sgtl5000@0a {
> > 		compatible = "fsl,sgtl5000";
> > 		reg = <0x0a>;
> > 		clocks = <&cko>;
> > 	};
> > 
> > mach-imx6q.c, imx6q_sabrelite_cko1_setup(): 
> > 
> >         cko1 = clk_get_sys(NULL, "cko1");
> >         clk_register_clkdev(cko1, NULL, "0-000a");
> > 
> 
> What!? This is a terrible abuse/hack of the clock binding and is in no
> way what was intended. You cannot use half of the clock binding. You
> have to have a provider. The primary binding is a phandle reference.
> clock-names is just auxiliary data.
> 
Well, on conversation [1], it seems people agreed that for those huge
clock tree, only leaf clocks should be exposed in device tree.  Then
please help me understand how we could do that with the current binding
design, considering those leaf clocks are consumers of their parent
clocks while being provider to the leaf clock the parent clock is not
exposed in device tree.

Regards,
Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/139414/focus=1216423
