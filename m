Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab2EBJxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:53:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45013 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2EBJxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:53:40 -0400
Date: Wed, 2 May 2012 10:53:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, kgene.kim@samsung.com, cjb@laptop.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] mmc: dw_mmc: lookup for optional biu and ciu clocks
Message-ID: <20120502095311.GZ24211@n2100.arm.linux.org.uk>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org> <1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335935266-25289-2-git-send-email-thomas.abraham@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 10:07:40PM -0700, Thomas Abraham wrote:
> Some platforms allow for clock gating and control of bus interface unit clock
> and card interface unit clock. Add support for clock lookup of optional biu
> and ciu clocks for clock gating and clock speed determination.

As we're moving progressively towards the common clk API, which requires
the new clk_prepare/clk_unprepare calls, new code should be using the
dated API.  Please update this to do so (eg, by using clk_prepare_enable()
instead of clk_enable() for the simple solution.)  Better solutions
involve decoupling the two and only using clk_enable()/clk_disable() where
you really need the clock to be on.
