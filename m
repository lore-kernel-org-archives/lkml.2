Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1HBRvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:51:02 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41345 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1HBRuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110802173343.GA5251@merkur.ravnborg.org>
References: <1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<1311947497-4958-1-git-send-email-mmarek@suse.cz>
	<20110802173343.GA5251@merkur.ravnborg.org>
Date: Tue, 2 Aug 2011 13:50:53 -0400
Message-ID: <CACqU3MUy_EBaVB_VHW0EcbMcV9Qn_H=oh4ZKkCaUuPtbezpC4A@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Introduce IS_ENABLED(), IS_BUILTIN() and IS_MODULE()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        xiyou.wangcong@gmail.com, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 2, 2011 at 1:33 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Fri, Jul 29, 2011 at 03:51:37PM +0200, Michal Marek wrote:
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
> Naming is good - has my ack.
>
>
>>
>> ---
>>  Makefile                   |    2 +-
>>  include/linux/kconfig.h    |   32 ++++++++++++++++++++
>>  scripts/kconfig/confdata.c |   71 ++++++++-----------------------------------
>>  3 files changed, 47 insertions(+), 58 deletions(-)
>>  create mode 100644 include/linux/kconfig.h
>>
>> diff --git a/Makefile b/Makefile
>> index afb8e0d..bd7629b 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -360,7 +360,7 @@ CFLAGS_GCOV       = -fprofile-arcs -ftest-coverage
>>  LINUXINCLUDE    := -I$(srctree)/arch/$(hdr-arch)/include \
>>                     -Iarch/$(hdr-arch)/include/generated -Iinclude \
>>                     $(if $(KBUILD_SRC), -I$(srctree)/include) \
>> -                   -include include/generated/autoconf.h
>> +                   -include $(srctree)/include/linux/kconfig.h
>
> If we do it like this then how about adding this to autoconf.h and avoid the extra file,
> and the extra flag to gcc?
>
That would be intrusive for non-Linux users of kconfig. You would have
to hardcode a <linux/kconfig.h> in autoconf.h, which mean other
project would have to either mirror the Linux include tree structure,
or modify kconfig for the desired include path, if the feature is
desired at all. As I see it, Linux, through Kbuild, is a user of
kconfig.

I might send a patch to conditionally generate the __enable_<FOO>
stuff so that other project have the choice to use this feature or not
(and avoid namespace utilization if not), but that's low priority.

 - Arnaud
