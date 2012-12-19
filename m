Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2LSKAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 05:00:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50666 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab2LSKAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 05:00:40 -0500
Message-ID: <50D19040.5090404@ti.com>
Date: Wed, 19 Dec 2012 11:00:32 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Felipe Balbi <balbi@ti.com>, Luciano Coelho <coelho@ti.com>,
        <svenkatr@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <cjb@laptop.org>, <lrg@ti.com>,
        <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
References: <1352968293.10872.51.camel@cumari.coelho.fi> <20121218095450.GB27751@arwen.pp.htv.fi> <20121219094552.GN4985@opensource.wolfsonmicro.com>
In-Reply-To: <20121219094552.GN4985@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 10:45 AM, Mark Brown wrote:
> On Tue, Dec 18, 2012 at 11:54:50AM +0200, Felipe Balbi wrote:
> 
>> damn, this is still part of our v3.7-rc kernel. Original commit was done
>> with no testing whatsoever and caused a big regression to (at least)
>> TI's WiFi driver which depend on SDIO to function.
> 
>> Too bad things break and even when reported nobody gives a rat's ***
>> about them :-s
> 
> I guess it's going to be even more of an issue going forward given the
> recent events but FWIW it was always very unusual to see any review of
> any TWL patches, the PMIC appeared to have been rather abandoned so the
> only way of getting any testing was to put stuff in -next and hope.

As for the twl-regulator I still have plan to do a major cleanup there. It is
just sad that it received the DT bindings for the current code. The DT support
addition would have been the perfect place to sanitize it. Now it is just
going to be a huge pain in the back.

As for the 32k clock:
I don't know the state of the common clock framework for OMAPs. Is it already
up in 3.7? Or going for 3.8? 3.9? 3.10?...
We need CCF to resolve this. I can cook up the clock driver for the 32k clock
from twl, but in order to use it we need CCF on OMAP.

-- 
Péter
