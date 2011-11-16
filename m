Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1KPSr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:47:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54188 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1KPSrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:47:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111114035908.GA10236@S2100-06.ap.freescale.net>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-4-git-send-email-grant.likely@secretlab.ca> <20111114035908.GA10236@S2100-06.ap.freescale.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Nov 2011 11:47:33 -0700
X-Google-Sender-Auth: oTxBJnizDNc9U2lW6W_cWWO3A9w
Message-ID: <CACxGe6t8-FT4Y+BYtq5yK5n-6vGCtBefKEFMRt2uKsMCF8zzVQ@mail.gmail.com>
Subject: Re: [RFC 3/8] of: create of_phandle_args to simplify return of
 phandle parsing data
To: Shawn Guo <shawn.guo@freescale.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 13, 2011 at 8:59 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> Hi Grant,
>
> On Tue, Nov 08, 2011 at 06:19:38PM -0700, Grant Likely wrote:
> [...]
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index 4948552..566deab 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -222,6 +222,13 @@ extern const void *of_get_property(const struct device_node *node,
>>  #define for_each_property(pp, properties) \
>>       for (pp = properties; pp != NULL; pp = pp->next)
>>
>> +#define MAX_PHANDLE_ARGS 8
>> +struct of_phandle_args {
>> +     struct device_node *np;
>> +     int args_count;
>> +     uint32_t args[MAX_PHANDLE_ARGS];
>> +};
>> +
>
> I'm seeing a bunch of warnings like the one below when compiling imx
> with the series.  And moving the definition to somewhere before
> '#include <asm/prom.h>' in linux/of.h removes the warnings for me.
>
>  CC      arch/arm/kernel/devtree.o
> In file included from arch/arm/plat-mxc/include/mach/irqs.h:14:0,
>                 from arch/arm/include/asm/irq.h:4,
>                 from arch/arm/include/asm/prom.h:17,
>                 from include/linux/of.h:133,
>                 from arch/arm/kernel/devtree.c:17:
> include/asm-generic/gpio.h:133:24: warning: ‘struct of_phandle_args’ declared inside parameter list
> include/asm-generic/gpio.h:133:24: warning: its scope is only this definition or declaration, which is probably not what you want

Fixed, thanks.

g.
