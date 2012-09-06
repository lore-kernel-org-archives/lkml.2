Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081Ab2IFAQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:16:44 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48770 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab2IFAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:16:43 -0400
MIME-Version: 1.0
In-Reply-To: <1346864831.1906.3.camel@joe2Laptop>
References: <20110525165345.5f775c7b.akpm@linux-foundation.org>
	<7f59aa30d3af02ae522dc38105e51107e34826f2.1306455946.git.joe@perches.com>
	<CAOoYnzLViwqp11Tw1zf0C+qhc+AtzefNLzZEbC2oUPkWPV5zqQ@mail.gmail.com>
	<1346864831.1906.3.camel@joe2Laptop>
Date: Thu, 6 Sep 2012 02:16:42 +0200
Message-ID: <CAOoYnzJULa5Pzkhm50ppMZ2qCAHD1KO09zGL6WjTwsqbe0LopA@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch: Suggest using min_t or max_t
From: Philippe De Muyter <philippe.demuyter@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 7:07 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-09-05 at 13:21 +0200, Philippe De Muyter wrote:
>> > v2: Make $match_balanced_parentheses work in perl 5.8
>>
>> Has this been applied  ?
>>
>> v3.3 version of checkpatch.pl works for me, but v3.4, v3.5 & v3.6rc2 say:
>> Nested quantifiers in regex; marked by <-- HERE in m/(\((?:[^\(\)]++
>> <-- HERE |(?-1))*\))/ at scripts/checkpatch.pl line 340.
>>
>> and my perl is :
>>
>>         perl --version
>>
>>         This is perl, v5.8.8 built for i586-linux-thread-multi
>
> The current version of checkpatch skips this
> check when the perl version is less than 5.10.0
>
>
> commit d7c76ba7e58bc3ca674f20759c686535db484749
> Author: Joe Perches <joe@perches.com>
> Date:   Tue Jan 10 15:09:58 2012 -0800
>
>     checkpatch: improve memset and min/max with cast checking
>
>     Improve the checking of arguments to memset and min/max tests.
>
>     Move the checking of min/max to statement blocks instead of single line.
>     Change $Constant to allow any case type 0x initiator and trailing ul
>     specifier.  Add $FuncArg type as any function argument with or without a
>     cast.  Print the whole statement when showing memset or min/max messages.
>     Improve the memset with 0 as 3rd argument error message.
>
>     There are still weaknesses in the $FuncArg and $Constant code as arbitrary
>     parentheses and negative signs are not generically supported.
>
> []
> # Using $balanced_parens, $LvalOrFunc, or $FuncArg
> # requires at least perl version v5.10.0
> # Any use must be runtime checked with $^V
> []
> # typecasts on min/max could be min_t/max_t
>                 if ($^V && $^V ge 5.10.0 &&
>                     defined $stat &&
>                     $stat =~ /^\+(?:.*?)\b(min|max)\s*\(\s*$FuncArg\s*,\s*$FuncArg\s*\)/) {
>
>

I know nothing about perl, and when I read 3.6rc2's checkpatch.pl it
seems to me that every usage of  $balanced_parens, $LvalOrFunc, or
$FuncArg is protected by a test for v5.10.0, but line 340, which perl
complains about, is not a use, but merely a definition.  Should the
definition not be protected too ?

Philippe
