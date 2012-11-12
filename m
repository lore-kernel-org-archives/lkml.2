Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2KLWnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 17:43:19 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58295 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2KLWnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 17:43:17 -0500
MIME-Version: 1.0
In-Reply-To: <1352175520.16194.14.camel@joe-AO722>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	<1352156701-4038-2-git-send-email-keescook@chromium.org>
	<1352175520.16194.14.camel@joe-AO722>
Date: Mon, 12 Nov 2012 14:43:16 -0800
X-Google-Sender-Auth: MP4zeOf5bIAf-rHnskSs7DOYcIc
Message-ID: <CAGXu5jL4-nKUdcY0qSivA0a4iG3ZguNr0yuF18kNTba6PsW-eA@mail.gmail.com>
Subject: Re: [PATCH 001/104] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 8:18 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-11-05 at 15:03 -0800, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, it is being removed.  This will discourage future addition of
>> CONFIG_EXPERIMENTAL while it is being phased out.
>>
>> Cc: Andy Whitcroft <apw@canonical.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  scripts/checkpatch.pl |    7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index 21a9f5d..f8b33ed 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -1757,6 +1757,13 @@ sub process {
>>                       #print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>>               }
>>
>> +# Discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
>> +             if ($realfile =~ /Kconfig/ &&
>> +                 $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
>> +                     WARN("CONFIG_EXPERIMENTAL",
>> +                          "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see:\nhttps://lkml.org/lkml/2012/10/23/580\n");
>> +             }
>> +
>>               if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>>                   ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>>                       my $flag = $1;
>
> Couple bits of trivia:
>
> Perhaps this would be better if it didn't just check Kconfig
> files and simply looked for any use of CONFIG_EXPERIMENTAL
>
>         $line =~ /^\+.*\bCONFIG_EXPERIMENTAL\b/
>
> I think the output WARN would be better on single line.
>
> "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives see https://lkml.org/lkml/2012/10/23/580\n"

Good idea! I've added a check for this now too. I made it look for
/^\+\s*\#if\s*.*\bCONFIG_EXPERIMENTAL\b/ just to limit it a bit more.

-Kees

-- 
Kees Cook
Chrome OS Security
