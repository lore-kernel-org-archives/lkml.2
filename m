Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2IZPEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 11:04:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54030 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926Ab2IZPEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 11:04:32 -0400
Date: Wed, 26 Sep 2012 16:04:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor out
 common code
Message-ID: <20120926150429.GQ4428@opensource.wolfsonmicro.com>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
 <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
 <20120925192048.GA17038@sirena.org.uk>
 <20120926145615.GJ10147@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926145615.GJ10147@mail.gnudd.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 04:56:15PM +0200, Davide Ciminaghi wrote:
> On Tue, Sep 25, 2012 at 08:20:48PM +0100, Mark Brown wrote:

> > Glancing at the diff here this looks a lot like regmap-mmio...  not sure
> > if it is or not, though.

> that would be ideal, but I also need to deal with the common clock framework,
> which doesn't support regmap: clk_register_divider(), clk_register_mux(),
> clk_register_gate(), all take a void __iomem * to access clock control
> registers, so as far as I can understand we can't use regmap, unless of
> course we convert the common clock framework to regmap.

The two should be able to coexist happily, regmap-mmio requires the
caller to do the actual mapping and so long as you don't cache the
relevant registers the two shouldn't interfere with each other.

Alternatively, and more generally usefully, we could implement regmap
based common clock helpers.
