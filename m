Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab1D1K2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:28:25 -0400
Received: from smtp.nokia.com ([147.243.128.24]:39861 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab1D1K2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:28:24 -0400
Message-ID: <4DB94122.9010203@nokia.com>
Date: Thu, 28 Apr 2011 13:27:46 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.18) Gecko/20110320 SeaMonkey/2.0.13
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: kalle.jokiniemi@nokia.com, lrg@slimlogic.co.uk, mchehab@infradead.org,
        svarbatov@mm-sol.com, saaguirre@ti.com, grosikopulos@mm-sol.com,
        vimarsh.zutshi@nokia.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Regulator state after regulator_get
References: <9D0D31AA57AAF5499AFDC63D6472631B09C76A@008-AM1MPN1-036.mgdnok.nokia.com> <4DB9348D.7000501@nokia.com> <9D0D31AA57AAF5499AFDC63D6472631B09C7BE@008-AM1MPN1-036.mgdnok.nokia.com> <20110428102009.GB14494@opensource.wolfsonmicro.com>
In-Reply-To: <20110428102009.GB14494@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Apr 28, 2011 at 09:44:10AM +0000, kalle.jokiniemi@nokia.com wrote:
> 
>>  > Another alternative to the first option you proposed could be to add a
>>  > flags field to regulator_consumer_supply, and use a flag to recognise
>>  > regulators which need to be disabled during initialisation. The flag
>>  > could be set by using a new macro e.g. REGULATOR_SUPPLY_NASTY() when
>>  > defining the regulator.
> 
>> This sounds like a good option actually. Liam, Mark, any opinions?
> 
> I'm not sure what "supply_nasty" would mean?  This also doesn't seem
> like something that we can set up per supply - it's going to affect the
> whole regulator state, it's not something that only affects a single
> supply.

supply_nasty() would be used to define a regulator which is enabled by
the boot loader when it shouldn't be, which is the actual problem.

We have a regulator which is enabled by the boot loader. However, this
regulator shouldn't be on at boot since it's not needed by any devices
--- the drivers for those devices will use proper regulator framework
calls to use the regulator when it's needed. There's no chance to have
the boot loader fixed, as stated by Kalle.

How should this regulator be turned off in the boot by the kernel?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
