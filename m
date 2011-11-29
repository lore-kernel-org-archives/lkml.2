Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1K2RYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:24:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33785 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1K2RYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <4ED4647D.4060305@linux.intel.com>
References: <20111128200951.GA3492@www.outflux.net>
	<4ED4647D.4060305@linux.intel.com>
Date: Tue, 29 Nov 2011 09:24:49 -0800
X-Google-Sender-Auth: CJUzdS2EeFY2vrN1Oi1l-14IjUw
Message-ID: <CAGXu5j+kzXpAhCYELDBBeMDPg2XMHt8jWRjZf2xiPVSMfUhjzA@mail.gmail.com>
Subject: Re: [PATCH v2] ramoops: use pstore interface
From: Kees Cook <keescook@chromium.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Tony Luck <tony.luck@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 8:50 PM, Chen Gong <gong.chen@linux.intel.com> wrote:
> 于 2011/11/29 4:09, Kees Cook 写道:
>>
>> Instead of using /dev/mem directly, use the common pstore infrastructure
>> to handle Oops gathering and extraction.
>>
>> Signed-off-by: Kees Cook<keescook@chromium.org>
>> ---
>> This depends on the pstore changes waiting for -next in:
>>
>> http://git.kernel.org/?p=linux/kernel/git/aegl/linux.git;a=shortlog;h=refs/heads/next
>> ---
>>  Documentation/ramoops.txt |    8 +-
>>  drivers/char/Kconfig      |    1 +
>>  drivers/char/ramoops.c    |  206
>> ++++++++++++++++++++++++++++++++++-----------
>>  3 files changed, 160 insertions(+), 55 deletions(-)
>>
>> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
>> index 8fb1ba7..a0b9d8e 100644
>> --- a/Documentation/ramoops.txt
>> +++ b/Documentation/ramoops.txt
>> @@ -3,7 +3,7 @@ Ramoops oops/panic logger
>>
>>  Sergiu Iordache<sergiu@chromium.org>
>>
>> -Updated: 8 August 2011
>> +Updated: 17 November 2011
>>
>>  0. Introduction
>>
>> @@ -71,6 +71,6 @@ timestamp and a new line. The dump then continues with
>> the actual data.
>>
>>  4. Reading the data
>>
>> -The dump data can be read from memory (through /dev/mem or other means).
>> -Getting the module parameters, which are needed in order to parse the
>> data, can
>> -be done through /sys/module/ramoops/parameters/* .
>> +The dump data can be read from the pstore filesystem. The format for
>> these
>> +files is "dmesg-ramoops-N", where N is the record number in memory. To
>> delete
>> +a stored record from RAM, simply unlink the respective pstore file.
>
> I think the definition of "mem_address" in the doc is not very clear. It is
> not a normal memory instead of a persistent RAM. I suggest adding more
> descriptions.
> It's better if there is a real example.

Okay. I'm not sure it's in the scope of this patch, but I can try.

Marco, do you have suggestions for how this could be enhanced?

>...
>> +       /* Only store crash dumps. */
>>        if (reason != KMSG_DUMP_OOPS&&
>>        reason != KMSG_DUMP_PANIC&&
>>        reason != KMSG_DUMP_KEXEC)
>
> As Andrew mentioned here (http://lkml.org/lkml/2011/11/28/495),
> who should take this responsibility to fix this issue when conflicting

Has the "remove KMSG_DUMP_KEXEC" patch been taken? I'm happy to drop
it from the ramoops patch. It's trivial to do so.

-Kees

-- 
Kees Cook
ChromeOS Security
