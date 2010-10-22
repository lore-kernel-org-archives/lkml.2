Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab0JVTez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:34:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45518 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747Ab0JVTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:34:54 -0400
Message-ID: <4CC1E717.7070707@ti.com>
Date: Fri, 22 Oct 2010 15:33:43 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: cyril@ti.com
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
References: <1287694873-12904-1-git-send-email-cyril@ti.com> <20101021161224.b4c0b623.akpm@linux-foundation.org> <4CC18605.80007@ti.com> <201010221448.17728.arnd@arndb.de>
In-Reply-To: <201010221448.17728.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 08:48 AM, Arnd Bergmann wrote:
> On Friday 22 October 2010 14:39:33 Cyril Chemparathy wrote:
>>>> +/* Register Access Helpers */
>>>> +static inline u32 ssp_read(struct ti_ssp *ssp, int reg)
>>>> +{
>>>> +    return __raw_readl(ssp->regs + reg);
>>>> +}
>>>> +
>>>> +static inline void ssp_write(struct ti_ssp *ssp, int reg, u32 val)
>>>> +{
>>>> +    __raw_writel(val, ssp->regs + reg);
>>>> +}
>>>
>>> Why are the __raw functions used here?
>>>
>>
>> These registers are to be accessed native endian at all times, and
>> therefore the le32 conversion done otherwise is inappropriate.
> 
> Won't that break on out-of-order CPUs that need the extra synchronization
> done in readl/writel?
> 

AFAICS, ioremap()ed space on ARMv6 should be strongly ordered.

>
> ...
>

Thanks
Cyril.
