Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2GRFmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 01:42:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15713 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2GRFmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 01:42:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Jul 2012 22:37:54 -0700
Message-ID: <50064AA7.3020508@nvidia.com>
Date: Wed, 18 Jul 2012 11:03:27 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/6] mfd: tps6586x:use devm managed resources
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com> <1342421510-10638-2-git-send-email-ldewangan@nvidia.com> <20120716200110.GD10774@opensource.wolfsonmicro.com> <5004ED3F.4080601@nvidia.com> <20120717165346.GH4477@opensource.wolfsonmicro.com>
In-Reply-To: <20120717165346.GH4477@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012 10:23 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jul 17, 2012 at 10:12:39AM +0530, Laxman Dewangan wrote:
>> On Tuesday 17 July 2012 01:31 AM, Mark Brown wrote:
>>> On Mon, Jul 16, 2012 at 12:21:45PM +0530, Laxman Dewangan wrote:
>
>> I think device_remove will get called before the managed resource
>> get freed.
>> So do we need to call disable_irq() in remove() to avoid any interrupts?
> That would be very rude if the IRQ happened to get shared, though that's
> not possible at the moment.  In general it's pretty hard to use devm_
> IRQs safely, it's normally safest to avoid them due to the issues with
> ensuring that the interrupt handler is safe to be called even while the
> device is being torn down.

OK, then I will revert this specific change if it is not safe. I will 
send the another patch (part of series v3 1/6) for this change only.
