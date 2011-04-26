Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab1DZPHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:07:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:61386 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab1DZPHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:07:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="425734431"
Date: Tue, 26 Apr 2011 17:07:47 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: davidb@codeaurora.org, dwalker@fifo99.com,
        linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: [PM8921 MFD V5 0/6] pm8921 core and subdevices
Message-ID: <20110426150746.GF3175@sortiz-mobl>
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhijeet,

On Tue, Apr 05, 2011 at 02:40:51PM -0700, Abhijeet Dharmapurikar wrote:
> This patch series adds support for pmic 8921 chip and its subdevices.
> The pmic 8921 chip is used as a power management ic for 8960 based boards. It
> communicates over the ssbi bus, ssbi bus can be found here
> 
> https://patchwork.kernel.org/patch/601771/
> 
> The patch set contains support for interrupt, gpio and mpp (multi purpose pin)
> subdevices.
> 
> Note that gpio and mpp subdevices need the interrupt subdevice to
> be operational, this is becuase the reading the the value of gpio/mpp lines
> happens by doing a transaction over registers managed by the interrupt subdev.
> The code invokes a call on interrupt subdevice, rather than writing to those
> registers directly, avoiding race conditions.
I have applied patch #1 and #2 to my for-next branch. For 3 and4, I'll wait
for Grant's ACK. As for #5, I'd like to get an ACK from the current MSM
maintainers.
Finally, patch #6 will be applied last.


> Updates from V4
> Few things have changed in kernel proper since I last sent this series
> -The interrupt macro names have changed (more structured)- had to update the irq
> patch to use the new macro names
> - mfd_cell does not have platfrom_data anymore - use mfd data instead.
I'm currently moving that away from the mfd_cell structure, in my for-next
branch. mfd_cell now has a platform_data pointer back, and you should use
mfd_get_cell() if you really need to reach the mfd_cell pointer (which you
apparently don't). 
Could you please generate patchs 3 and 4 against this branch ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
