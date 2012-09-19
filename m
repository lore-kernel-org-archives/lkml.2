Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2ISWjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:39:17 -0400
Received: from nm12.bullet.mail.sp2.yahoo.com ([98.139.91.82]:46985 "HELO
	nm12.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752636Ab2ISWip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:38:45 -0400
X-Yahoo-Newman-Id: 115991.79283.bm@omp1008.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 25.ggiUVM1nR1.UMBy5uiKaJHmvziA2Ka0qV9uCbQiMtOpt
 L0lyrGYkNi5t9gtzGvB1kOMESS1ziGTUkWM_GxsJoDEXuQC_S_TtWr.jB_G8
 7FkiUe1dTa__FsdQRjolWOunSxSN2ATc3BSAfXdMdTYbeBokYmYKyirznCuf
 7lFrGhaEPpuC8FxMm5kxFqR2c8u4RNY_qMKovGEqTzw6HpunBc1acnx1pMy8
 xB3w7B4d6dvQ.AJVQSj2mReUwIVej_u38Dx9FwOnoFjK0f7IcorKmFYsVZvA
 YYQq7_AbPZHczXCyNWplOrChA9_1MWJpAHZ1p8B3ERZgBuosywvoIqYzrMDS
 BqhdkaTGOQvOAKiQcix_OX5Sk97Ozl8M1yfWkO_H2Ejms5TcMb8lMxxd1OzG
 xupLuhfNFgv9gAptEC5dnxA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <505A499F.1040102@att.net>
Date: Wed, 19 Sep 2012 17:39:27 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Where to put test code?
References: <505A3EAB.2030002@att.net> <CAFTL4hyF9c5e91JbVxGyo5RSjm3XuvRmhxXLExamZub3ae5KTg@mail.gmail.com>
In-Reply-To: <CAFTL4hyF9c5e91JbVxGyo5RSjm3XuvRmhxXLExamZub3ae5KTg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the response!

On 09/19/2012 05:18 PM, Frederic Weisbecker wrote:
> 2012/9/19 Daniel Santos <danielfsantos@att.net>:
>> I'm putting the finishing touches on the generic red-black tree test
>> code, but I'm uncertain about where to place it exactly.
>>
>> I haven't finished the test module just yet, but the idea is that the
>> tests can be run in userspace as well as kernelspace to make it easier
>> to test on multiple compilers.  It has some common sources files (used
>> by in both places) and then specific code for both user- and
>> kernel-space that I currently have as follows:
>>
>> tools/testing/selftests/grbtree/       - common.{c,h}
>> tools/testing/selftests/grbtree/user   - user-space main.c, Makefile, etc.
>> tools/testing/selftests/grbtree/module - kernel-space grbtest.c,
>> Makefile, etc.
>>
>> Would this be correct or should the common & module code go some place
>> else and then just have the user-space code under
>> tools/testing/selftests/grbtest?
> It depends on the nature of your tests. Are these pure validation
> tests (some batch
> tests that perform actions and check the result is correct) or stress
> tests (something
> that runs for a while)?
The program does both performance measurement tests and validation tests
based upon what you pass at the command line.  The primary aim is to
measure performance differences between the generic code and specific
(hand-coded) implementations on various compilers.  The secondary aim is
to provide validation that the results are correct in all
circumstances.  I'm not sure in this case what would be considered a
"stress" test.

> If these are only about validation tests, then both user and module
> can be in that
> tools/testing/selftests directory.
>
> What is the module doing?
The module is the exact same thing, except built in kernel-space, where
the actual code will normally reside.  Parameters are passed when you
load the module and it unloads when the test is complete.  Perhaps what
I omitted is that the user-space program is generated partially by
compiling sources and headers that are intended for kernel-space only,
but linked with glibc using some cute hacks.  This is done mostly to
ease the process of testing the code with multiple compilers.

Daniel
