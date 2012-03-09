Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2CILkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 06:40:41 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:55157 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CILkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 06:40:39 -0500
MIME-Version: 1.0
In-Reply-To: <1331264145.3105.56.camel@pasglop>
References: <1331263072-9612-1-git-send-email-mla@apm.com>
	<1331264145.3105.56.camel@pasglop>
Date: Fri, 9 Mar 2012 06:40:38 -0500
Message-ID: <CA+5PVA4sbuRsxO7Qv5RU8J+i1QcYGjS9O45ev-JRJz6B=i4Mfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/44x: Fix PCI MSI support for Maui APM821xx
 SoC and Bluestone board
From: Josh Boyer <jwboyer@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mai La <mla@apm.com>, Michael Neuling <mikey@neuling.org>,
        open-source-review@apm.com, Tirumala R Marri <tmarri@apm.com>,
        linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 10:35 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2012-03-09 at 10:17 +0700, Mai La wrote:
>> This patch consists of:
>> - Enable PCI MSI as default for Bluestone board
>> - Define number of MSI interrupt for Maui APM821xx SoC using in Bluestone board
>> - Fix returning ENODEV as finding MSI node
>> - Fix MSI physical high and low address
>> - Keep MSI data logically
>>
>> Signed-off-by: Mai La <mla@apm.com>
>> ---
>
>> index 7b4df37..c86231e 100644
>> --- a/arch/powerpc/sysdev/Kconfig
>> +++ b/arch/powerpc/sysdev/Kconfig
>> @@ -20,6 +20,12 @@ config PPC_MSI_BITMAP
>>       default y if FSL_PCI
>>       default y if PPC4xx_MSI
>>
>> +config PPC4xx_NR_MSI_IRQS
>> +     int "Number of PCI MSI interrupts"
>> +     depends on PCI_MSI && PPC4xx_MSI
>> +     default "4" if !APM821xx
>> +     default "8" if APM821xx
>> +
>
>  .../...
>
>> +#define NR_MSI_IRQS CONFIG_PPC4xx_NR_MSI_IRQS
>
> ARGH.
>
> We asked to -NOT MAKE THIS A COMPILE TIME OPTION-

Actually, I asked for basically exactly above.  I was _wrong_ in asking,
but it was asked for.

> CONFIG_foo is as bad as your previous ifdef, in fact you just added a
> useless config option here.
>
> Make that number dynamic. Count the entries in the device-tree (or add
> a property with the number in it, whatever you fancy the most) but make
> it something detected at RUNTIME !!!!!

My apologies Mai.  Ben is correct here and I should have thought more
about my suggestion before I made it.

josh
