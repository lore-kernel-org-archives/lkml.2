Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab2GENMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:12:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46549 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab2GENMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:12:12 -0400
Message-ID: <4FF592A9.5050706@linaro.org>
Date: Thu, 05 Jul 2012 14:12:09 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <20120703142123.GQ29030@opensource.wolfsonmicro.com> <4FF54406.3000307@linaro.org> <20120705094541.GK4111@opensource.wolfsonmicro.com> <4FF57EA9.7060107@linaro.org> <20120705120600.GT4111@opensource.wolfsonmicro.com> <4FF58571.2090807@linaro.org> <20120705122947.GY4111@opensource.wolfsonmicro.com> <4FF58B68.5000703@linaro.org> <20120705124549.GD4111@opensource.wolfsonmicro.com> <4FF58ED6.40106@linaro.org> <20120705130306.GI4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120705130306.GI4111@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 14:03, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 01:55:50PM +0100, Lee Jones wrote:
>> On 05/07/12 13:45, Mark Brown wrote:
>
>>> Right, so what I'm saying is that what I'd expect unless there's
>>> something unusual going on is that you wouldn't be doing the separate
>>> registration of the AB8500 here and would instead be passing the
>>> platform data for the AB8500 through in the same way you pass the DT
>>> data through.
>
>> Then were would you register it, if not here?
>
> Same place as for DT.

That is a possibility, but the idea is to reduce code in the platform 
area, not add to it. We'd also need a completely separate platform_data 
structure to the one we use for platform registration, as much of it has 
now been moved into Device Tree. The regulators are a good example of 
this, but there's also GPIO information which is no longer relevant etc.

I do believe that registering the AB8500 from the DB8500 is appropriate 
though, for the simple reason that the AB8500 is a sub-device to the 
DB8500. I think this is the correct thing to do. But anyway, as I said 
before, that ship has sailed. We _already_ do this. All this patch does 
is prevent the AB8500 from being registered twice when DT is not enabled.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


