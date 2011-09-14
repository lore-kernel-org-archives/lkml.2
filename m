Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1INFXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 01:23:19 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38119 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1INFXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 01:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <4E69FEC9.2080204@suse.cz>
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
	<4E69FEC9.2080204@suse.cz>
Date: Wed, 14 Sep 2011 01:17:10 -0400
Message-ID: <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target list
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/9/9 Michal Marek <mmarek@suse.cz>:
> On 25.8.2011 03:03, Arnaud Lacombe wrote:
>> This avoid an extra make invocation on `prepare0'.
>>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>> ---
>>  Kbuild   |    4 +++-
>>  Makefile |    1 -
>>  2 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/Kbuild b/Kbuild
>> index 2114113..1a2eb32 100644
>> --- a/Kbuild
>> +++ b/Kbuild
>> @@ -88,10 +88,12 @@ $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
>>  # 3) Check for missing system calls
>>  #
>>
>> +always += missing-syscalls
>> +targets += missing-syscalls
>> +
>>  quiet_cmd_syscalls = CALL    $<
>>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
>
> checksyscalls.sh needs to depend on generated/asm-offsets.h, otherwise a
> parallel build will fail.
>
true.

This:

diff --git a/Kbuild b/Kbuild
index 1a2eb32..4caab4f 100644
--- a/Kbuild
+++ b/Kbuild
@@ -94,7 +94,7 @@ targets += missing-syscalls
 quiet_cmd_syscalls = CALL    $<
       cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)

-missing-syscalls: scripts/checksyscalls.sh FORCE
+missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
        $(call cmd,syscalls)

 # Keep these two files during make clean


should do the job.

 - Arnaud
