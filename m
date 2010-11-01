Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0KASbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:31:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab0KASbQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vmI9akPJH6Bofx+pU2omcOZKIXarqDyTY2SLG3Z5fD+V2tNbia5LWiL1AdhiR8EbtT
         bS8dyR7BTR7TQ70glPsxuR13xKGlE0JQVlGGNucaIYR0WAR1fLk8/9uHOqnpLuL68pXg
         nj6/QB/1qJAmHBHUMqOZUfxorFsPFs7Vf0iPU=
MIME-Version: 1.0
In-Reply-To: <4CCC9AEB.7060101@fluff.org>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
	<1287608139-21354-3-git-send-email-alchark@gmail.com>
	<4CCC9AEB.7060101@fluff.org>
Date: Mon, 1 Nov 2010 21:31:14 +0300
Message-ID: <AANLkTini9jZHtH+Bp4dgdQ6A-=7iAe71YJ_KnMjJqbTN@mail.gmail.com>
Subject: Re: [PATCH 3/6] input: Add support for VIA VT8500 and compatibles in i8042
From: Alexey Charkov <alchark@gmail.com>
To: Ben Dooks <ben-linux@fluff.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/31 Ben Dooks <ben-linux@fluff.org>:
> On 20/10/10 21:55, Alexey Charkov wrote:
>> VIA and WonderMedia Systems-on-Chip feature a standard i8042-compatible
>> keyboard and mouse controller. This adds necessary glue to enable use
>> of the standard driver with these systems.
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> ---
>>
>> Please review and state whether this could be acceptable for a merge
>> to mainline in the coming 2.6.37 window. If possible, I would deeply
>> appreciate a merge to a relevant git tree for integration prior to
>> asking Linus to pull the changes. I could rebase the code if needed,
>> currently this is against Linus' master branch.
>>
>> This patch relies on the basic architecture support for VT8500/WM8505
>> to be in place, as introduced by PATCH 1/6 in this series.
>>
>> Due credits go to the community for providing feedback, advice and
>> testing.
>>
>> NB: The development is being done at:
>> http://gitorious.org/linux-on-via-vt8500/vt8500-kernel
>>
>> Relevant code may be pulled from a git tree in there.
>>
>>  drivers/input/serio/Kconfig        |    3 +-
>>  drivers/input/serio/i8042-vt8500.h |   71 ++++++++++++++++++++++++++++++++++++
>>  drivers/input/serio/i8042.h        |    2 +
>>  3 files changed, 75 insertions(+), 1 deletions(-)
>>  create mode 100644 drivers/input/serio/i8042-vt8500.h
>>
>> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
>> index 3bfe8fa..2b86774 100644
>> --- a/drivers/input/serio/Kconfig
>> +++ b/drivers/input/serio/Kconfig
>> @@ -21,7 +21,8 @@ if SERIO
>>  config SERIO_I8042
>>       tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
>>       default y
>> -     depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
>> +     depends on !PARISC && \
>> +               (!ARM || ARCH_SHARK || ARCH_VT8500 || FOOTBRIDGE_HOST) && \
>>                  (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
>
> this looks like someone could do with a HAS_SERIO_I8042 Kconfig entry
> and have the relevant archs select it instead of having this mess.
>
>

True, it would make things much cleaner. However, that's probably out
of scope of adding VT8500 support here, thus not for me to decide :)

<snip>

>
> yeurk... how about having a core i8042 implementation and having
> a structure with the necessary callbacks for the code, so that
> we don't end up having to select what is builtin for the system
> we're compiling for?
>

I would really like to see this implemented as a standard platform
driver (accepting resources and platform_data as necessary). This
would be a way cleaner approach, with less code duplication and less
patching of the driver itself whenever a new platform is to be added.
However, I don't know how that kind of a change would affect other
arches.

> --
> Ben
>

Thanks,
Alexey
