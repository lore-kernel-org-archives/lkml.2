Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1BYCFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:05:08 -0500
Received: from www.wytron.com.tw ([211.75.82.101]:35815 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1BYCFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:05:07 -0500
Message-ID: <4D670E4B.6000407@wytron.com.tw>
Date: Fri, 25 Feb 2011 10:04:59 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org, Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH v6] i2c-gpio: add devicetree support
References: <20110223011232.GC15795@trinity.fluff.org> <1298520013-3630-1-git-send-email-thomas@wytron.com.tw> <20110224162210.GC17735@angua.secretlab.ca>
In-Reply-To: <20110224162210.GC17735@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.15
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 02/25/2011 12:22 AM, Grant Likely wrote:
>> +Required properties:
>> +- compatible : should be "i2c-gpio".
>> +- gpios : should specify GPIOs used for SDA and SCL lines, in that order.
>> +Optional properties:
>> +- sda-is-open-drain : present if SDA gpio is open-drain.
>> +- scl-is-open-drain : present if SCL gpio is open-drain.
>> +- scl-is-output-only : present if the output driver for SCL cannot be
>> +	turned off. this will prevent clock stretching from working.
>> +- speed-hz : SCL frequency.
>
> Hi Thomas,
>
> One nitpick; I just looked, and other i2c controllers are already
> using 'clock-frequency' instead of 'speed-hz' for the speed of the
> bus.  I'd like to see this patch use the same terminology.

I studied 'clock-frequency' usage of existing i2c drivers before working 
on this patch.

i2c-ibm_iic.c, i2c-mpc.c, i2c-ocores.c : use as bus clock frequency 
input to the core.

i2c-cpm.c : use as i2c SCL output frequency.

Most other non-i2c drivers use clock-frequency as bus clock frequency 
input, too.

I think the SCL freq usage in i2c-cpm.c is confusing. So I would suggest 
we borrow 'speed-hz' from spi subsystem, which means the clock freq 
output on the peripheral bus.

Best regards,
Thomas

