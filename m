Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab2IKKQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:16:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:41395 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab2IKKQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:16:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,402,1344236400"; 
   d="scan'208";a="143730389"
Date: Tue, 11 Sep 2012 12:16:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: core: Push irqdomain mapping out into devices
Message-ID: <20120911101643.GM3647@sortiz-mobl>
References: <1347347796-26925-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347347796-26925-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark, Lee,

On Tue, Sep 11, 2012 at 03:16:36PM +0800, Mark Brown wrote:
> Currently the MFD core supports remapping MFD cell interrupts using an
> irqdomain but only if the MFD is being instantiated using device tree
> and only if the device tree bindings use the pattern of registering IPs
> in the device tree with compatible properties.  This will be actively
> harmful for drivers which support non-DT platforms and use this pattern
> for their DT bindings as it will mean that the core will silently change
> remapping behaviour and it is also limiting for drivers which don't do
> DT with this particular pattern.  There is also a potential fragility if
> there are interrupts not associated with MFD cells and all the cells are
> omitted from the device tree for some reason.
> 
> Instead change the code to take an IRQ domain as an optional argument,
> allowing drivers to take the decision about the parent domain for their
> interrupts.  The one current user of this feature is ab8500-core, it has
> the domain lookup pushed out into the driver.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> This should incorporate a fix Lee Jones created for ab8500, though he
> was only able to describe it verbally and not send a patch so I'd like
> some confirmation from him that it's OK.
I'm applying this one to my for-linus branch and I'd like to send a pull
request to Linus in a few days. Lee, could you please confirm that it's OK
with you ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
