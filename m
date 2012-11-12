Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2KLXLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:11:48 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33249 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2KLXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <1352761583.18715.16.camel@joe-AO722>
References: <20121112225019.GA23718@www.outflux.net>
	<1352761583.18715.16.camel@joe-AO722>
Date: Mon, 12 Nov 2012 15:11:44 -0800
X-Google-Sender-Auth: sUEs9Nh2g6c0sT1E4P7YjzrW34g
Message-ID: <CAGXu5jLyWv6jN_iQ+NvDMy5f2o_AN2eJTQGpOzshB3VSnL1pOg@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 3:06 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-11-12 at 14:50 -0800, Kees Cook wrote:
>> This config item has not carried much meaning for a while now and is
>> almost always enabled by default. As agreed during the Linux kernel
>> summit, it is being removed.  This will discourage future addition of
>> CONFIG_EXPERIMENTAL while it is being phased out.
>
> You should also cc Andrew Morton (cc'd)
>
>> Cc: Andy Whitcroft <apw@canonical.com>
>> Cc: Joe Perches <joe@perches.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  scripts/checkpatch.pl |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
>> index f18750e..41e364b 100755
>> --- a/scripts/checkpatch.pl
>> +++ b/scripts/checkpatch.pl
>> @@ -1757,6 +1757,15 @@ sub process {
>>                       #print "is_start<$is_start> is_end<$is_end> length<$length>\n";
>>               }
>>
>> +# discourage the addition of CONFIG_EXPERIMENTAL in Kconfig.
>> +             if ($realfile =~ /Kconfig/ &&
>> +                 $line =~ /.\s*depends on\s+.*\bEXPERIMENTAL\b/) {
>
> This is after the deleted lines check so this won't trigger
> on deleted lines.

Correct -- I don't want to trigger on deleted lines. That's what we
want to see in patches. :)

>> +                     WARN("CONFIG_EXPERIMENTAL",
>> +                          "Use of CONFIG_EXPERIMENTAL is deprecated. " +
>> +                          "For alternatives, see " +
>> +                          "https://lkml.org/lkml/2012/10/23/580\n");
>
> I'd much prefer this be on a single line and not using the +
> string operator as that style is not currently used in checkpatch.

Hah. Okay. We should exclude checkpatch.pl from the 80 character check
it warns about. ;)

>> +             }
>> +
>>               if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
>>                   ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
>>                       my $flag = $1;
>> @@ -1912,6 +1921,14 @@ sub process {
>>  # check we are in a valid C source file if not then ignore this hunk
>>               next if ($realfile !~ /\.(h|c)$/);
>>
>> +# discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
>> +             if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
>
> Same as previous reply just a few minutes ago
>
> There are many config uses like:
>         #if defined(CONFIG_FOO)
> and
>         #if defined CONFIG_FOO || defined CONFIG_BAR

Right, this will catch those. "if.*" above

> so I think any line that has this specific config option is suspect.
>> +                     WARN("CONFIG_EXPERIMENTAL",
>> +                          "Use of CONFIG_EXPERIMENTAL is deprecated. " +
>> +                          "For alternatives, see " +
>> +                          "https://lkml.org/lkml/2012/10/23/580\n");
>> +             }
>
>
>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
