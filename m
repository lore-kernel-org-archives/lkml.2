Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab1DRLLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:11:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63793 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1DRLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:10:56 -0400
Message-ID: <4DAC1C3B.6020205@monstr.eu>
Date: Mon, 18 Apr 2011 13:10:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, w.sang@pengutronix.de, arnd@arndb.de
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <20110418103513.GA27864@linux-sh.org>
In-Reply-To: <20110418103513.GA27864@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> On Mon, Apr 18, 2011 at 10:50:54AM +0200, Michal Simek wrote:
>> Adding OF binding to genirq.
>> Version string is setup to the "devicetree".
>>
>> Compatible string is not setup for now but you can add your
>> custom compatible string to uio_of_genirq_match structure.
>>
>> For example with "uio" compatible string:
>> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>> 	{ .compatible = "uio", },
>> 	{ /* empty for now */ },
>> };
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>
> Perhaps a silly question, but how are you planning on differentiating
> between uio_pdrv and uio_pdrv_genirq binding if someone has both enabled?

It is not a silly question. OF support in uio_pdrv_genirq can handle both cases 
with/without IRQ (I tested it) and I don't want to add OF support to uio_pdrv.
Not sure if uio_pdrv_genirq without OF can handle UIO without IRQ.

> uio_pdrv obviously doesn't have OF bindings at the moment, but it seems
> like you could easily parse the memory ranges in addition to the IRQ and
> come up with a generic binding that would work for both.

I think the question is if uio_pdrv_genirq can handle both cases, if yes, we can 
completely remove uio_pdrv. But it is up to UIO maintainers.

> 
> We also have a shiny new Documentation/devicetree these days, so it would
> be nice to see the binding documented at the same time.

Sure - make sense.

Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
