Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2ICT7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:59:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47785 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab2ICT7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:59:45 -0400
MIME-Version: 1.0
In-Reply-To: <87392zgbij.fsf@sejong.aot.lge.com>
References: <CANg8OWKxb_sMXSSpf0iHVn4+a8QF1-b1cKX+jBiWzBYamGNjrw@mail.gmail.com>
 <87392zgbij.fsf@sejong.aot.lge.com>
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 3 Sep 2012 22:59:23 +0300
Message-ID: <CANg8OW+rBXgVaboip0JCmmTb_1Gzt6R3kUju2Y8iYvj6=pnzYQ@mail.gmail.com>
Subject: Re: [PATCH 08/13] perf tools: Use __maybe_used for unused variables
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:07 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi,

Hi,

>
> On Wed, 29 Aug 2012 01:04:25 +0300, Irina Tirdea wrote:
>> perf defines __used to for marking unused variables.
>> The variable __used is defined to __attribute__((__unused__)), which
>> contradicts the kernel definition to __attribute__((__used__))
>> for new gcc versions. On Android), __used is also defined in
>> system headers and this leads to warnings like:
>> warning: '__used__' attribute ignored
>>
>> This patch simply replaces all instances of __used with __maybe_unused
>> so there will be no such warnings.
>
> How about just using '__unused' for less typing?

Replacing __used with __unused leads to conflicts with glibc headers,
since glibc has a variable named __unused in the stat.h header. I
forgot to mention this in the commit message.

This is the error:
In file included from /usr/include/x86_64-linux-gnu/sys/stat.h:107:0,
                 from util/util.h:48,
                 from builtin-bench.c:20:
/usr/include/x86_64-linux-gnu/bits/stat.h:106:22: error: expected
identifier or ‘(’ before ‘[’ token
/usr/include/x86_64-linux-gnu/bits/stat.h:167:22: error: expected
identifier or ‘(’ before ‘[’ token
make: *** [builtin-bench.o] Error 1

> Btw, the patch looks whitespace-damaged.

That's true. I'll fix it.

Thanks,
Irina
