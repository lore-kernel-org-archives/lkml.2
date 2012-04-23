Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2DWRf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:35:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55044 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab2DWRf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:35:56 -0400
References: <1335150198-21899-1-git-send-email-konrad.wilk@oracle.com> <201204231334.51376.rjw@sisk.pl>
User-Agent: K-9 Mail for Android
In-Reply-To: <201204231334.51376.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL/PATCH] gts and bfs fixes (v5).
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 23 Apr 2012 10:34:44 -0700
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Message-ID: <b4633284-02f7-454b-a35a-2bf844db05c6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do I have your ACK?

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

>On Monday, April 23, 2012, Konrad Rzeszutek Wilk wrote:
>> Please git pull (or use the patches that follow this email) the
>following branch:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
>stable/for-x86-for-3.4
>> 
>> Changes since v4 [https://lkml.org/lkml/2012/4/18/396]
>>  - Added Acked and Reviewed-by
>> v2 [https://lkml.org/lkml/2012/4/9/474]
>>  - ditched the assembler version and used a C wrapper
>> 
>> With git commit a2ef5c4fd44ce3922435139393b89f2cce47f576
>> "ACPI: Move module parameter gts and bfs to sleep.c" the
>> sampling of gts/bfs module parameters flag by acpi_enter_sleep_state
>> has been moved. It has been moved out of the inner ACPI code and
>> out in the more x86 specific. This means that any caller of
>> the exported acpi_enter_sleep_state function needs to provide
>> two parameters now: sleep state and the bit flag whether to us
>_GTS|_BFS.
>> 
>> All of the callers of acpi_enter_sleep_state did that, with
>> the exception of the assembler version and as well any
>> third-party callers of acpi_enter_sleep_state.
>> 
>> These two patches expose 'wake_sleep_flags' as the product
>> of the gts/bfs module parameter invocation. And also use said
>> flag in the assembler 'do_suspend_lowlevel()' function.
>> 
>> Konrad Rzeszutek Wilk (2):
>>       ACPI: Convert wake_sleep_flags to a value instead of function
>(v5)
>>       x86/acpi: Call acpi_enter_sleep_state via an asmlinkage C
>function from assembler (v2).
>> 
>>  arch/x86/kernel/acpi/sleep.c     |    4 +++
>>  arch/x86/kernel/acpi/sleep.h     |    4 +++
>>  arch/x86/kernel/acpi/wakeup_32.S |    4 +--
>>  arch/x86/kernel/acpi/wakeup_64.S |    4 +--
>>  drivers/acpi/sleep.c             |   52
>++++++++++++++++++++-----------------
>>  5 files changed, 38 insertions(+), 30 deletions(-)
>
>Peter, are you going to take this?
>
>Rafael

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
