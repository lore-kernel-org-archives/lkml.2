Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1EBQFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 12:05:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1EBQFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 12:05:23 -0400
Message-ID: <4DBED641.8080605@suse.cz>
Date: Mon, 02 May 2011 18:05:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, bp@alien8.de, sam@ravnborg.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com
Subject: Re: [PATCH] kbuild: Allow to combine multiple W= levels
References: <71633.1304013549@localhost>	<1304083893-18849-1-git-send-email-mmarek@suse.cz>	<20110502153813.GC15769@sepie.suse.cz> <BANLkTi=xfP_1guk5ZuCj0R_r=XqaGwZw-w@mail.gmail.com>
In-Reply-To: <BANLkTi=xfP_1guk5ZuCj0R_r=XqaGwZw-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.5.2011 17:53, Arnaud Lacombe wrote:
> Hi Michal,
>
> On Mon, May 2, 2011 at 11:38 AM, Michal Marek<mmarek@suse.cz>  wrote:
>> On Fri, Apr 29, 2011 at 03:31:33PM +0200, Michal Marek wrote:
>>> Add support for make W=12, make W=123 and so on, to enable warnings from
>>> multiple W= levels. Normally, make W=<level>  does not include warnings
>>> from the previous level.
>>>
>>> Signed-off-by: Michal Marek<mmarek@suse.cz>
>>> ---
>>>   scripts/Makefile.build |    8 ++++++--
>>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
>>> index 9c0c481..28cef2a 100644
>>> --- a/scripts/Makefile.build
>>> +++ b/scripts/Makefile.build
>>> @@ -60,6 +60,8 @@ endif
>>>   # $(call cc-option, -W...) handles gcc -W.. options which
>>>   # are not supported by all versions of the compiler
>>>   ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
>>> +warning-  := $(empty)
>>> +
>>>   warning-1 := -Wextra -Wunused -Wno-unused-parameter
>>>   warning-1 += -Wmissing-declarations
>>>   warning-1 += -Wmissing-format-attribute
>>> @@ -85,9 +87,11 @@ warning-3 += -Wswitch-default
>>>   warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
>>>   warning-3 += $(call cc-option, -Wvla)
>>>
>>> -warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
>>> +warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>>> +warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>>> +warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
>>>
>>> -ifeq ("$(warning)","")
>>> +ifeq ("$(strip $(warning))","")
>>>           $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
>>>   endif
>>
>> Pushed to kbuild-2.6.git#kbuild with the following make help update:
>>
> you did not comment on the point I raised.

Valdis did. Why is it a problem that W=123 can be interchanged with W=321?

Michal
