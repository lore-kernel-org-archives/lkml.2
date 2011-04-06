Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1DFPH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 11:07:59 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:45045 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab1DFPH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 11:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cBFWLZ9BC4O9MQTzB8z0w92lI3jkNr4sPIdLJ1iPGVjXx/ZKhX9+80Y/k9A4zufjJ5
         UiDN2xTXq4IC4Wt3ijAS5IbiKsA5cMVp8uYPFkqWjt5wkrKOfqq8SQkar7C2Rs2/UYP9
         EyMey2gsHqbertytAQ/HPWzgaC7ondaA+qQaM=
MIME-Version: 1.0
In-Reply-To: <20110405131504.1d182da4@schlenkerla.am.freescale.net>
References: <1302022702-24541-1-git-send-email-justinmattock@gmail.com>
	<1302022702-24541-2-git-send-email-justinmattock@gmail.com>
	<20110405131504.1d182da4@schlenkerla.am.freescale.net>
Date: Wed, 6 Apr 2011 08:07:58 -0700
Message-ID: <BANLkTi=5A1P-WAFvCyjbT7RVva9K9d=gQQ@mail.gmail.com>
Subject: Re: [RFC 2/5]arch:powerpc:sysdev:Makefile Remove unused config in the Makefile.
From: Justin Mattock <justinmattock@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: trivial@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Harninder Rai <harninder.rai@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 11:15 AM, Scott Wood <scottwood@freescale.com> wrote:
> On Tue, 5 Apr 2011 09:58:19 -0700
> "Justin P. Mattock" <justinmattock@gmail.com> wrote:
>
>> The patch below removes an unused config variable found by using a kernel
>> cleanup script.
>> Note: I did try to cross compile these but hit erros while doing so..
>> (gcc is not setup to cross compile) and am unsure if anymore needs to be done.
>> Please have a look if/when anybody has free time.
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>> CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> CC: linuxppc-dev@lists.ozlabs.org
>>
>> ---
>>  arch/powerpc/sysdev/Makefile |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
>> index 1e0c933..243b6ad 100644
>> --- a/arch/powerpc/sysdev/Makefile
>> +++ b/arch/powerpc/sysdev/Makefile
>> @@ -18,7 +18,6 @@ obj-$(CONFIG_FSL_PMC)               += fsl_pmc.o
>>  obj-$(CONFIG_FSL_LBC)                += fsl_lbc.o
>>  obj-$(CONFIG_FSL_GTM)                += fsl_gtm.o
>>  obj-$(CONFIG_MPC8xxx_GPIO)   += mpc8xxx_gpio.o
>> -obj-$(CONFIG_FSL_85XX_CACHE_SRAM)    += fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
>>  obj-$(CONFIG_SIMPLE_GPIO)    += simple_gpio.o
>>  obj-$(CONFIG_FSL_RIO)                += fsl_rio.o
>>  obj-$(CONFIG_TSI108_BRIDGE)  += tsi108_pci.o tsi108_dev.o
>
> Those files do exist, and aren't pulled in by any other means I can see.
> It was introduced by commit 6db92cc9d07db9f713da8554b4bcdfc8e54ad386, whose
> changelog says:
>        Drivers can do the following in Kconfig to use these APIs "select
> FSL_85XX_CACHE_SRAM if MPC85xx"
>
> Now, the absence of such a kconfig option[1] is a problem, but I don't think
> outright removal (labelled "trivial cleanup") is appropriate, unless nobody
> fixes it after the problem is pointed out.  And if it is removed, the files
> should go with it.
>
> -Scott
>
> [1] and of any drivers that select it, though this was added fairly
> recently -- perhaps such a driver change is on its way?
>
>

ahh.. so the:  fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o is still in use
even though FSL_85XX_CACHE_SRAM is not really used, but really is used!!

but might be wrong with this.

-- 
Justin P. Mattock
