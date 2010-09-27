Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab0I0HI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:08:59 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50256 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab0I0HI5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Mon, 27 Sep 2010 03:08:57 -0400
Message-Id: <4CA05F220200007800018F81@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 27 Sep 2010 08:08:50 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Guenter Roeck" <guenter.roeck@ericsson.com>
Cc: <r.marek@assembler.cz>, <fenghua.yu@intel.com>, <khali@linux-fr.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
 <20100924185509.GA20155@ericsson.com>
In-Reply-To: <20100924185509.GA20155@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.09.10 at 20:55, Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> On Mon, Sep 13, 2010 at 10:26:33AM -0000, Jan Beulich wrote:
>> PCI specific code is needed only when Atom CPUs are potentially
>> supported by the kernel.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Cc: Rudolf Marek <r.marek@assembler.cz>
>> 
>> ---
>> drivers/hwmon/Kconfig |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> 
>> 
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
>> Please read the FAQ at  http://www.tux.org/lkml/ 
>> 
>> --- linux-2.6.36-rc4/drivers/hwmon/Kconfig	2010-09-13 08:45:02.000000000 +0200
>> +++ 2.6.36-rc4-x86-coretemp-maybe-pci/drivers/hwmon/Kconfig	2010-09-10 
> 16:24:16.000000000 +0200
>> @@ -401,7 +401,8 @@ config SENSORS_GL520SM
>>  
>>  config SENSORS_CORETEMP
>>  	tristate "Intel Core/Core2/Atom temperature sensor"
>> -	depends on X86 && PCI && EXPERIMENTAL
>> +	depends on X86 && EXPERIMENTAL
>> +	depends on PCI || (!MATOM && !GENERIC_CPU && !X86_GENERIC)
>>  	help
>>  	  If you say yes here you get support for the temperature
>>  	  sensor inside your CPU. Most of the family 6 CPUs
> 
> Resending my reply to this one as well. Again, apologies if there is 
> duplication.
> 
> The coretemp code unconditionally calls pci functions, even if PCI is not 
> defined.
> I am concerned that this might cause problems. It might be better to stick 
> with
> the more generic dependency instead of trying to optimize too much.

pci.h takes care to define stub inline functions for the !CONFIG_PCI
case. It seemed largely odd for a driver like this to depend on PCI
at all, and hence I think it is more transparent to make the needs
explicit.

Jan

