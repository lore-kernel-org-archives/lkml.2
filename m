Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab2ITKvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:51:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38232 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2ITKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:51:07 -0400
MIME-Version: 1.0
In-Reply-To: <505A499F.1040102@att.net>
References: <505A3EAB.2030002@att.net>
	<CAFTL4hyF9c5e91JbVxGyo5RSjm3XuvRmhxXLExamZub3ae5KTg@mail.gmail.com>
	<505A499F.1040102@att.net>
Date: Thu, 20 Sep 2012 12:51:06 +0200
Message-ID: <CAFTL4hzjK1C2G9Un+HF4cj_kYJCjTfxFC=nMh09mhYvTd4W2JQ@mail.gmail.com>
Subject: Re: Where to put test code?
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/20 Daniel Santos <danielfsantos@att.net>:
> Thanks for the response!
>
> On 09/19/2012 05:18 PM, Frederic Weisbecker wrote:
>> 2012/9/19 Daniel Santos <danielfsantos@att.net>:
>>> I'm putting the finishing touches on the generic red-black tree test
>>> code, but I'm uncertain about where to place it exactly.
>>>
>>> I haven't finished the test module just yet, but the idea is that the
>>> tests can be run in userspace as well as kernelspace to make it easier
>>> to test on multiple compilers.  It has some common sources files (used
>>> by in both places) and then specific code for both user- and
>>> kernel-space that I currently have as follows:
>>>
>>> tools/testing/selftests/grbtree/       - common.{c,h}
>>> tools/testing/selftests/grbtree/user   - user-space main.c, Makefile, etc.
>>> tools/testing/selftests/grbtree/module - kernel-space grbtest.c,
>>> Makefile, etc.
>>>
>>> Would this be correct or should the common & module code go some place
>>> else and then just have the user-space code under
>>> tools/testing/selftests/grbtest?
>> It depends on the nature of your tests. Are these pure validation
>> tests (some batch
>> tests that perform actions and check the result is correct) or stress
>> tests (something
>> that runs for a while)?
> The program does both performance measurement tests and validation tests
> based upon what you pass at the command line.  The primary aim is to
> measure performance differences between the generic code and specific
> (hand-coded) implementations on various compilers.  The secondary aim is
> to provide validation that the results are correct in all
> circumstances.  I'm not sure in this case what would be considered a
> "stress" test.

Ok. The selftests in tools/testing/selftest run in batch, so if there
is one in the middle that does stress tests for a while, it delays the
other tests. The purpose for these units tests are to quickly detect
for regressions or anything that break expected results.

Your test sounds like a good candidate for that directory I guess.

>
>> If these are only about validation tests, then both user and module
>> can be in that
>> tools/testing/selftests directory.
>>
>> What is the module doing?
> The module is the exact same thing, except built in kernel-space, where
> the actual code will normally reside.  Parameters are passed when you
> load the module and it unloads when the test is complete.  Perhaps what
> I omitted is that the user-space program is generated partially by
> compiling sources and headers that are intended for kernel-space only,
> but linked with glibc using some cute hacks.  This is done mostly to
> ease the process of testing the code with multiple compilers.

Ok, looks good as well.

Thanks!
