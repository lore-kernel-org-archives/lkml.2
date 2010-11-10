Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab0KJRQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:16:03 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42290 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268Ab0KJRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:16:01 -0500
Message-ID: <4CDAD2FE.3020506@euromail.se>
Date: Wed, 10 Nov 2010 18:14:38 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup table
 (rev2)
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se> <1289315711-3011-5-git-send-email-rydberg@euromail.se> <1289329469.22931.221.camel@groeck-laptop> <4CD9A1DC.2000407@euromail.se> <1289336024.22931.243.camel@groeck-laptop> <4CDA7A94.7070302@euromail.se> <20101110154235.GA31170@ericsson.com>
In-Reply-To: <20101110154235.GA31170@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGEFs-0007R9-4g.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PGEFs-0007R9-4g e94d4a209085ed5928f3724e34543b5a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>

>> Looking at this again, it seems there are two other problems as well. Firstly,
>> the cache memory is not freed after probe failure, my apologies. Secondly,
>> execution continues after a probe failure, and the initialization is retried. I
>> would like to push the latter problem to some other occasion, since the whole
>> platform logic should be rewritten for the new interface, anyways.
>>
> I see the cache problem; this is indeed a tricky one, since it is actually not yet
> a problem after this patch, but will be one after patch 5.
> 
> I don't understand the second problem, though. Looking into the code,
> the probe function will return an error if applesmc_init_smcreg() fails.
> Am I missing something ? What execution continues ?


I think drivers/base/dd.c:142 shows the problem clearly. Basically, the probe
function is supposed to do the proper initialization, if successful. The driver
code has been rewritten heavily since the days of the applesmc, and the actual
probe error is now masked in a rather ugly fashion to allow the driver matching
to continue. It seems to me that the only clean way around this is to actually
implement the correct platform driver logic.

Thanks,
Henrik
