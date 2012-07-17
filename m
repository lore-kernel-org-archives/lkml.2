Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab2GQEu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:50:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4884 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GQEuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:50:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Jul 2012 21:50:54 -0700
Message-ID: <5004ED3F.4080601@nvidia.com>
Date: Tue, 17 Jul 2012 10:12:39 +0530
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
References: <1342421510-10638-1-git-send-email-ldewangan@nvidia.com> <1342421510-10638-2-git-send-email-ldewangan@nvidia.com> <20120716200110.GD10774@opensource.wolfsonmicro.com>
In-Reply-To: <20120716200110.GD10774@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2012 01:31 AM, Mark Brown wrote:
> On Mon, Jul 16, 2012 at 12:21:45PM +0530, Laxman Dewangan wrote:
>
>> -	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
>> -				   "tps6586x", tps6586x);
>> +	ret = devm_request_threaded_irq(tps6586x->dev, irq, NULL, tps6586x_irq,
>> +			IRQF_ONESHOT, "tps6586x", tps6586x);
> Are you sure this is safe - what guarantees that we can't get an
> interrupt while tearing the device down?

I think device_remove will get called before the managed resource get 
freed.
So do we need to call disable_irq() in remove() to avoid any interrupts?


