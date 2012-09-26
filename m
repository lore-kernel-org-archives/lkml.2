Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2IZO4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:56:33 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:34554 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab2IZO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:56:31 -0400
Date: Wed, 26 Sep 2012 16:56:15 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out common code
Message-ID: <20120926145615.GJ10147@mail.gnudd.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com> <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com> <20120925192048.GA17038@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120925192048.GA17038@sirena.org.uk>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 08:20:48PM +0100, Mark Brown wrote:
> On Wed, Sep 12, 2012 at 12:22:47PM +0200, ciminaghi@gnudd.com wrote:
> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > 
> > A driver for the apb-soc registers is needed by the clock
> > infrastructure code to configure and control clocks on the sta2x11
> > chip.
> > Since some of the functions in sta2x11-mfd.c were almost identical
> > for the two existing platform devices, the following changes
> > have been performed to avoid further code duplication while
> > adding the apb-soc-regs driver:
> 
> Glancing at the diff here this looks a lot like regmap-mmio...  not sure
> if it is or not, though.

that would be ideal, but I also need to deal with the common clock framework,
which doesn't support regmap: clk_register_divider(), clk_register_mux(),
clk_register_gate(), all take a void __iomem * to access clock control
registers, so as far as I can understand we can't use regmap, unless of
course we convert the common clock framework to regmap.

Thanks
Davide
