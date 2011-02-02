Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1BBIP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 03:15:29 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:56120 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab1BBIP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:15:28 -0500
Message-ID: <4D49128B.9030403@stericsson.com>
Date: Wed, 2 Feb 2011 09:15:07 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Arun MURTHY <arun.murthy@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com> <4D382C9F.6000108@stericsson.com> <F45880696056844FA6A73F415B568C69537384B9F3@EXDCVYMBSTM006.EQ1STM.local> <4D39770C.20208@stericsson.com> <20110201113617.GB10128@sortiz-mobl>
In-Reply-To: <20110201113617.GB10128@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 12:36 PM, Samuel Ortiz wrote:
> As subdevices, I expect users to have an ab8500 pointer. So it would just be
> one dereference.
I do not want users to have or use the ab8500 pointer at all. I would 
like to move it from the .h file into the ab8500-core.c eventually.

> As I'm not familiar with your HW architecture, could you please describe how
> those accessories would wire into the ab8500 core ?
The accessories can for example be a simple phone headset, a carkit and 
so on. A headset wire into the 3.5mm plug and gpadc can be used to 
understand whats plugged in. Our analog baseband chip ab8500 is a 
container of subfunctionality like audio codec, digital encoder, voltage 
regulators and so on.
The idea behind ab8500-core driver is to provide register access and 
interrupt management to the subdrivers implementing the 
subfunctionality. The gpadc driver is one these subdrivers. A headset 
driver becomes a subdriver of the gpadc wich is a subdriver to 
ab8500-core so the question is how far we should enforce these hierarchy 
of drivers.
In my opinion the line goes here. The gpadc provides a service to 
convert. Open for not only subdrivers and the rational is to reduce 
complexity.
> If those devices really are independent drivers (i.e. not subdevices) needing
> to get an A/D conversion from the ab8500 adc (I don't see how that can happen,
> hence my above question), then it might make sense to use a conversion API
> independent from any ab8500 pointer. But otherwise, I prefer this API rather
> than the one in v2 of this patch.
You are absolutely right that really independent drivers of ab8500 will 
probably not be found and I understand your argument. But many parts in 
our platform have connections to ab8500 via regulators, clocks or other 
wires. The decision is instead based on design to reduce complexity. If 
a driver uses direct register access to ab8500 then it should be a 
subdriver (to enforce startup order for example) otherwise is is not 
required (in my oppinion). An accessory driver should easily be ported 
from other platforms and not be tied to ab8500.

Me and Arun got some feedback to keep our discussion internal first so 
sorry for keeping you out the last mails but the result is patch v2.

Thanks and regards,
Mattias Wallin
