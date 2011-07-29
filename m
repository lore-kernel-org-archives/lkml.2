Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1G2S6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:58:06 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52644 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1G2S6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:58:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110729112526.db528361.rdunlap@xenotime.net>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<1311947497-4958-1-git-send-email-mmarek@suse.cz>
	<20110729112526.db528361.rdunlap@xenotime.net>
Date: Fri, 29 Jul 2011 14:58:03 -0400
Message-ID: <CACqU3MXWpkbyn9D23pk7mB5M_NeC0zieWXAmN4Cz=_PTJOaRrg@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        xiyou.wangcong@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 29, 2011 at 2:25 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Fri, 29 Jul 2011 15:51:37 +0200 Michal Marek wrote:
>
>> Replace the config_is_*() macros with a variant that allows for grepping
>> for usage of CONFIG_* options in the code. Usage:
>>
>>   if (IS_ENABLED(CONFIG_NUMA))
>>
>> or
>>
>>   #if IS_ENABLED(CONFIG_NUMA)
>>
>> The IS_ENABLED() macro evaluates to 1 if the argument is set (to either 'y'
>> or 'm'), IS_BUILTIN() tests if the option is 'y' and IS_MODULE() test if
>> the option is 'm'. Only boolean and tristate options are supported.
>>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>
>> Everybody happy with the above naming?
>
> Yes here.
>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
> These strings are being written to the .config file, right?
>
no, they are written to `include/generated/autoconf.h'

 - Arnaud

>> +             /*
>> +              * Generate the __enabled_CONFIG_* and
>> +              * __enabled_CONFIG_*_MODULE macros for use by the
>> +              * IS_{ENABLED,BUILTIN,MODULE} macros. The _MODULE variant is
>> +              * generated even for booleans so that the IS_ENABLED() macro
>> +              * works.
>> +              */
>> +             fprintf(fp, "#define __enabled_" CONFIG_ "%s %d\n",
>> +                             sym->name, (*value == 'y'));
>> +             fprintf(fp, "#define __enabled_" CONFIG_ "%s_MODULE %d\n",
>> +                             sym->name, (*value == 'm'));
>>               break;
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
