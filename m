Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab1EZTlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:41:44 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:45771 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1EZTlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p1lnTg+O+17Gc/2qhCEvNAodhpclHf9KcJXbKTIEoPor893ms8bRxngAXzLJ7mvuDp
         nj//NisSwdPHpGv5XxszdEYnaHETfjyeFo2AAQPp/tBPqOkLd6AB64/tQJ2n2ok0b9x8
         qDii2YK1k8GrdJ/Q79IfqG2CJdSJ+3jEkZ7I4=
MIME-Version: 1.0
In-Reply-To: <20110525124401.GB29300@elte.hu>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-3-git-send-email-jim.cromie@gmail.com> <20110521103315.GA23651@elte.hu>
 <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com> <20110525124401.GB29300@elte.hu>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Thu, 26 May 2011 13:41:12 -0600
Message-ID: <BANLkTimJp9o5_P73eNn5rMJbfRC2sCRdJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dont commify big numbers by default, let -B do it
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 6:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jim Cromie <jim.cromie@gmail.com> wrote:
>
>> > Also, i think for automation we'd also like to have a 'simple
>> > output' mode, would you like to add that?
>>
>> OK, heres 1st cut at it, adding option --simple, for review /
>> feedback
>>
>> Its based upon the csv-output code mostly, with some vestiges of
>> verbose..
>
> Ok, we can do something like this - but please see the comments on
> the patch further below:
>
>> > Something a bit like what you can see in 'perf stat -v true':
>> > Without the human output later on, and with elapsed time added as
>> > well.
>>
>> for my part, Id like the moral equivalent of time(s)? output too,
>> though I suspect thats a separate patch..
>
> yeah. No objection to that either: time is well known and the stddev
> output by perf stat --repeat is well liked. Wanna combine the two?

I think so, depending upon what exactly 'combining' means.

>>
>> real  0m3.019s
>> user  0m0.005s
>> sys   0m0.012s
>>
>> are these timings already taken by perf-stat ?
>> is it a simple matter of addition and printing ?
>> If not, whats involved ?
>
> Do you mean the real/user/sys bits? Elapsed time is already measured,
> but you'd have to extract the rusage bits to get to the stime/utime
> values.
>

> We could also add those as explicit events.

ISTM this makes sense - make them 1st class objects,
rather than some crufty fiddling in builtin-stats.
Can you give me a few hints re what/where to add ?

Also, is it sensible/practical to add self / +children flavors

>
>> Also, task-clock-msec doesnt quite match up with times' user number
>> Whats going on here ?
>
> task-clock-msec is generally much more accurate than the 0.005
> printed by 'time'.
>
> About the patch:
> We *really* want something cleaner here: a print_ops vector of
> function pointers which would contain a handful of helper functions
> called by the higher level code?

added struct print_ops:
0001-perf-stat-refactor-print-formatting-into-print-ops-f.patch
0002-perf-stat-fix-nan-in-Aa-runs.patch
0003-perf-stat-clean-up-no-count-handling-CPUx-prefixing.patch

sending separately, will attempt to in-reply-to them here.

> Also, instead of adding -s/--simple we really want a single
> print-format option that knows about all the format 'drivers':
>
>  --print simple
>  --print csv
>  --print default
>  --print verbose
>
> or so.

I left it as -x <delim> , since simple is basically csv.
in csv, "<not counted>" becomes "<not-counted>"
since latter makes -x ' ' useful.
also added -x '\t'  --> tab


> Also, please run scripts/checkpatch.pl over your patches, the above
> is i think not matching the coding style we use in the kernel (unless
> webmail mangled your patch).

emacs did it.  I didnt fuss to correct cuz patch wasnt for prime-time.
Now corrected with .emacs additions from CodingStyle.
and checkpatched.

thanks

>
> Thanks,
>
>        Ingo
>
