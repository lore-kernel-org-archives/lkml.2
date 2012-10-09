Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JIGio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:38:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19858 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2JIGim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:38:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 08 Oct 2012 23:27:50 -0700
Message-ID: <5073BE7F.5060107@nvidia.com>
Date: Tue, 9 Oct 2012 11:34:47 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: Convert tps6586x to irq_domain
References: <1349712805-10014-1-git-send-email-ldewangan@nvidia.com> <1349712805-10014-2-git-send-email-ldewangan@nvidia.com> <20121009060641.GE8237@opensource.wolfsonmicro.com> <5073BAA8.4060404@nvidia.com> <20121009062355.GJ8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009062355.GJ8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2012 11:53 AM, Mark Brown wrote:
> On Tue, Oct 09, 2012 at 11:18:24AM +0530, Laxman Dewangan wrote:
>> On Tuesday 09 October 2012 11:36 AM, Mark Brown wrote:
>>> but can you convert to regmap_irq?
>> Yes, the motivation was this when I started this cleanups but found
>> that there is 4 interrupt status and 5 interrupt mask register.
>> Probably we need to pass the number of interrupt status and
>> interrupt mask register to expand the regmap-irq framework to handle
>> this case also. If it is fine then I can work towards that.
> Can you explain in more detail - I guess there's a different mapping of
> the bits into the registers for mask and status (in which case the
> generic code just won't work anyway).
The bit definitions are also different in status and mask register and 
yes, this will be again problem as we do in isr thread
  data->status_buf[i] &= ~data->mask_buf[i];

So given the constraint, generic will not work here.

