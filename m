Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab1EBPx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:53:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41635 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1EBPx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q4z2fGIW2fr5eUk1bRee/esqnEFg6KbrNoW9KSEqiRrSkf9+gv8xrs78LuCjUc4Lo7
         HTjHxKHJFRyxhZuipMNmxhNehMsacgkskV9txW7VSORtFWbFG+IkaZYNuxEAdjz8xJlP
         O0gFwKWGIuyqCRnmKXVKk5Ygyvwbfk4MRga/I=
MIME-Version: 1.0
In-Reply-To: <20110502153813.GC15769@sepie.suse.cz>
References: <71633.1304013549@localhost>
	<1304083893-18849-1-git-send-email-mmarek@suse.cz>
	<20110502153813.GC15769@sepie.suse.cz>
Date: Mon, 2 May 2011 11:53:55 -0400
Message-ID: <BANLkTi=xfP_1guk5ZuCj0R_r=XqaGwZw-w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Valdis.Kletnieks@vt.edu, bp@alien8.de, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, May 2, 2011 at 11:38 AM, Michal Marek <mmarek@suse.cz> wrote:
> On Fri, Apr 29, 2011 at 03:31:33PM +0200, Michal Marek wrote:
>> Add support for make W=12, make W=123 and so on, to enable warnings from
>> multiple W= levels. Normally, make W=<level> does not include warnings
>> from the previous level.
>>
>> Signed-off-by: Michal Marek <mmarek@suse.cz>
>> ---
>>  scripts/Makefile.build |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
>> index 9c0c481..28cef2a 100644
>> --- a/scripts/Makefile.build
>> +++ b/scripts/Makefile.build
>> @@ -60,6 +60,8 @@ endif
>>  # $(call cc-option, -W...) handles gcc -W.. options which
>>  # are not supported by all versions of the compiler
>>  ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
>> +warning-  := $(empty)
>> +
>>  warning-1 := -Wextra -Wunused -Wno-unused-parameter
>>  warning-1 += -Wmissing-declarations
>>  warning-1 += -Wmissing-format-attribute
>> @@ -85,9 +87,11 @@ warning-3 += -Wswitch-default
>>  warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>>  warning-3 += $(call cc-option, -Wvla)
>>
>> -warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
>> +warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>> +warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>> +warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>>
>> -ifeq ("$(warning)","")
>> +ifeq ("$(strip $(warning))","")
>>          $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
>>  endif
>
> Pushed to kbuild-2.6.git#kbuild with the following make help update:
>
you did not comment on the point I raised.

Thanks,
 - Arnaud

> diff --git a/Makefile b/Makefile
> index 4527dc2..d342502 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1290,7 +1290,7 @@ help:
>        @echo  '                1: warnings which may be relevant and do not occur too often'
>        @echo  '                2: warnings which occur quite often but may still be relevant'
>        @echo  '                3: more obscure warnings, can most likely be ignored'
> -
> +       @echo  '                Multiple levels can be combined with W=12 or W=123'
>        @echo  ''
>        @echo  'Execute "make" or "make all" to build all targets marked with [*] '
>        @echo  'For further info see the ./README file'
>
> Michal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
