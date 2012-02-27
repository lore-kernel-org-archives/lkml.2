Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2B0Oan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:30:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:32310 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2B0Oal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:30:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129860950"
Date: Mon, 27 Feb 2012 15:38:06 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MFD: TWL 6030: clear IRQ status register only once
Message-ID: <20120227143806.GP27687@sortiz-mobl>
References: <1329962625-29767-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329962625-29767-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishan,

On Wed, Feb 22, 2012 at 08:03:45PM -0600, Nishanth Menon wrote:
> TWL6030 family of PMIC use a shadow interrupt status register
> while kernel processes the current interrupt event.
> However, any write(0 or 1) to register INT_STS_A, INT_STS_B or
> INT_STS_C clears all 3 interrupt status registers.
> 
> Since clear of the interrupt is done on 32k clk, depending on I2C
> bus speed, we could in-adverently clear the status of a interrupt
> status pending on shadow register in the current implementation.
> This is due to the fact that multi-byte i2c write operation into
> three seperate status register could result in multiple load
> and clear of status and result in lost interrupts.
> 
> Instead, doing a single byte write to INT_STS_A register with 0x0
> will clear all three interrupt status registers without the related
> risk.
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
