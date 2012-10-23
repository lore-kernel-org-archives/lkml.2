Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742Ab2JWXS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:18:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53740 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663Ab2JWXSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:18:53 -0400
MIME-Version: 1.0
In-Reply-To: <20121023225919.GB3179@localhost>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-3-git-send-email-keescook@chromium.org>
	<20121023225919.GB3179@localhost>
Date: Tue, 23 Oct 2012 16:18:52 -0700
X-Google-Sender-Auth: gEKKUvlU-2SfDxl_GaMSeE1mMt8
Message-ID: <CAGXu5jLh0Y69G5ZA1W9A_2aVGoGcEgkcV0HUV5HyocLQKNvssg@mail.gmail.com>
Subject: Re: [PATCH 002/193] checkpatch: warn about using CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:59 PM, Andy Whitcroft <apw@canonical.com> wrote:
> On Tue, Oct 23, 2012 at 01:01:15PM -0700, Kees Cook wrote:
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
>> index 21a9f5d..37dc932 100755
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
>> +                          "Use of CONFIG_EXPERIMENTAL is deprecated.\n");
>> +             }
>> +
>
> Seem reasonable.  Should you suggest how they can mark things
> experimental?  I assume (EXPERIMENTAL) in the title is now the right
> way?

Yeah, there's an escalation that seemed to get agreed on:
https://lkml.org/lkml/2012/10/23/580

I could add a hint to read the above lkml post?

-Kees

-- 
Kees Cook
Chrome OS Security
