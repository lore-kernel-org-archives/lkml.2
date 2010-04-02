Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0DBQ0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:26:34 -0400
Received: from mga07.intel.com ([143.182.124.22]:21682 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752168Ab0DBQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:26:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,353,1267430400"; 
   d="scan'208";a="261522576"
Date: Fri, 2 Apr 2010 18:27:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Improve WM831x AUXADC completion handling
Message-ID: <20100402162704.GM8010@sortiz.org>
References: <1270222263-14203-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270222263-14203-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 04:31:03PM +0100, Mark Brown wrote:
> Currently completion of WM831x AUXADC conversions is monitored by
> checking for convertor enable. Due to the mechanism used to ensure
> data corruption is avoided when reading AUXADC data there may under
> heavy I/O be a window where this bit has cleared but the conversion
> results have not been updated. Data availability is only guaranteed
> after the AUXADC data interrupt has been asserted.
> 
> Avoid this by always using the interrupt to detect completion. If the
> chip IRQ is not set up then we poll the IRQ status register for up to
> 5ms. If it is set up then we rely on the data done interrupt with a
> vastly increased timeout, failing the conversion if the interrupt is
> not generated.
> 
> This also saves a register read when using interrupts.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
