Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1GHKQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 06:16:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38897 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1GHKQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 06:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <201107071848.50411.richard@nod.at>
References: <1310056668.3528.51.camel@vivanov>
	<201107071848.50411.richard@nod.at>
Date: Fri, 8 Jul 2011 13:16:20 +0300
Message-ID: <CAGTPOqfT=L4s8-db58mCRXQFvuYOVwNsNDfc4YuRaO7azpZa4A@mail.gmail.com>
Subject: Re: [PATCH 3/3] uml: os-Linux/main.c memory leak fix
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 7:48 PM, Richard Weinberger <richard@nod.at> wrote:
> Am Donnerstag 07 Juli 2011, 18:37:48 schrieb Vitaliy Ivanov:
>> >From 6db3c87f57e3e61d968da79f01fb21ba17fd5bc0 Mon Sep 17 00:00:00 2001
>>
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Thu, 7 Jul 2011 19:29:06 +0300
>> Subject: [PATCH 3/3] uml: os-Linux/main.c memory leak fix
>>
>> We should cleanup memory even though 'putenv' fails.
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>> ---
>>  arch/um/os-Linux/main.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
>> index fb2a97a..67fe012 100644
>> --- a/arch/um/os-Linux/main.c
>> +++ b/arch/um/os-Linux/main.c
>> @@ -107,8 +107,8 @@ static void setup_env_path(void)
>>       snprintf(new_path, path_len, "PATH=%s" UML_LIB_PATH, old_path);
>>       if (putenv(new_path)) {
>>               perror("couldn't putenv to set a new PATH");
>> -             free(new_path);
>>       }
>> +     free(new_path);
>
> Uhhh, this will kill the PATH variable.
> putenv() does not copy the string...

That's actually depends on the version of glibc that you use. But yes,
agree, my fault. Please drop this one.
I hope I'm not in your shit-list already.:)

BTW, you said that you will share your git tree on kernel.org, is
there any news? I'm tracking what patches are accepted not to resend
them again.

Thanks,
Vitaliy
