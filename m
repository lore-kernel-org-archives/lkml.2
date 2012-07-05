Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2GEMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:41:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48595 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2GEMlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:41:15 -0400
Message-ID: <4FF58B68.5000703@linaro.org>
Date: Thu, 05 Jul 2012 13:41:12 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <20120703123552.GC25995@sirena.org.uk> <4FF2EEA1.6080204@linaro.org> <20120703132447.GN29030@opensource.wolfsonmicro.com> <4FF2F82D.9080507@linaro.org> <20120703142123.GQ29030@opensource.wolfsonmicro.com> <4FF54406.3000307@linaro.org> <20120705094541.GK4111@opensource.wolfsonmicro.com> <4FF57EA9.7060107@linaro.org> <20120705120600.GT4111@opensource.wolfsonmicro.com> <4FF58571.2090807@linaro.org> <20120705122947.GY4111@opensource.wolfsonmicro.com>
In-Reply-To: <20120705122947.GY4111@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 13:29, Mark Brown wrote:
> On Thu, Jul 05, 2012 at 01:15:45PM +0100, Lee Jones wrote:
>> On 05/07/12 13:06, Mark Brown wrote:
>
>>> You seemed to be suggesting that your fix was in some way related to the
>>> DT changes in the MFD core.  I'm unsure as to the relationship here.
>
>> How is it not related? In English the patch would say; "Only
>> register the AB8500 via the MFD API when we're booting with Device
>> Tree. This allows AB8500 related devices to be registered in the
>> normal way, rather than registering them individually using DT and
>> prevents duplicate registration when we are not executing a Device
>> Tree enabled boot."
>
> This is what you said before and it still doesn't make much sense to me.
> I'd expect that if anything your first statement would be the opposite
> of what happens - it seems like your non-DT code is doing something
> really odd.  If anything I'd expect adding a DT to add duplicate
> registrations, I'd not expect it to remove registrations.
>
> What I'd expect is that if we can figure out that we need to register
> the AB8500 automatically without any information from DT then we should
> be able to figure out exactly the same thing in the non-DT case.  I
> would therefore expect that the change would instead be something which
> removes the other source of registrations.

Now you're confusing me. :)

If DT is _not_ enabled, we do:

   From platform code:
    - Register the DB8500-PRCMU
    - Register the AB8500

So you see the registration is separate.

If DT _is_ enabled, we do:

   From Device Tree:
    - Register the DB8500-PRCMU (which in turn registers the AB8500)

In this case we the DB8500-PRCMU goes on to register the AB8500 for us, 
so we need to ensure DT _is_ running before we go on to do that, because 
if we don't the DB8500-PRCMU will register it and so will platform code.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


