Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652Ab1EMJc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:32:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60657 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab1EMJcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wLI76aTPmeBUjh69qMVyqu+FpLib+15PbKA/Dzxm0a1L6n1l4bNM18BRUK7zT/SnJf
         8DwG1qndJXd3ZScd6DLFHzLSG7Ehpz9auP+MEEQ+IP2+8i9Wf/IMK0qc7l4zMDRI/in3
         nBe6PMIAS3J6LGYriEvu38EWuy+cmpYHhnk2E=
MIME-Version: 1.0
In-Reply-To: <BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
References: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
	<BANLkTim-FmuENeU_Cai+nYnTP+uJTEn3PA@mail.gmail.com>
	<BANLkTi=S3VR1mxc0bsL4+N3ksHeo3scg3A@mail.gmail.com>
	<009c01cc108b$4635c7d0$d2a15770$@com>
	<BANLkTi=wg=RgyEWzL9_fwUymhFDaccQCfw@mail.gmail.com>
	<BANLkTin9RLjsgu=frPGXL8mL8p8LPz-10w@mail.gmail.com>
	<BANLkTik=M8uwnmHABqYBkeVDk56UMrnkMg@mail.gmail.com>
	<BANLkTi=VesNU8ye=ntq-LAzBPG4pVYZPQQ@mail.gmail.com>
	<BANLkTik6c8-g8FrXZy8-V35W6-Th++5p_A@mail.gmail.com>
Date: Fri, 13 May 2011 17:32:53 +0800
Message-ID: <BANLkTi=bYzYrHx+P=yTH_0VTiQaGZHeB9A@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkjTogcHJvYmxlbSB3aXRoIGttZW1sZWFr?=
From: ttlxzz ccc <boyzccc@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Wang and Catalin:

I have tested kmemleak on the x86 and x86_64 architecture again. There is only
 backtrace:

   [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffffc90012d27000 (size 64):

 comm "insmod", pid 13092, jiffies 4298369684

 hex dump (first 32 bytes):

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

 backtrace:

   [<ffffffffffffffff>] 0xffffffffffffffff

But in the x86, there is full backtrace.
 I do this below
> cat .config | grep STACETRACE
>
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_STACKTRACE=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
>
> As you see, the x86_64 architecture supprot stacktrace. But I found
> there's no backtrace yesterday.
> I'll test it again later.
>
> BTW
>
> cat /proc/cpuinfo | grep processor | wc -l
> 8
> cat /proc/cpuinfo | grep model
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz

and My linux version is redhat 3.4.5

Is it a problem of x86_64 architecture or something else? I am really
very Anxious.

Thanks:)

On Fri, May 13, 2011 at 11:58 AM, ttlxzz ccc <boyzccc@gmail.com> wrote:
> Hi, wang
> I have test kmemleak on the x86 architecture. There is no problem with
> full backtrace.
> But I can't test it on the x86_64 because my test machine is doing
> something else.:(
> But I do this below
> cat .config | grep STACETRACE
>
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_STACKTRACE=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
>
> As you see, the x86_64 architecture supprot stacktrace. But I found
> there's no backtrace yesterday.
> I'll test it again later.
>
> BTW
>
> cat /proc/cpuinfo | grep processor | wc -l
> 8
> cat /proc/cpuinfo | grep model
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
> model           : 26
> model name      : Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz
>
> thank you :)
>
>
> On Thu, May 12, 2011 at 10:49 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Thu, May 12, 2011 at 10:33 PM, ttlxzz ccc <boyzccc@gmail.com> wrote:
>>> Thanks for Wangcong
>>>
>>> I have test the kmemleak-test.ko and the result includes no backtrace
>>> except fffffffff, too.
>>> I'm compling the kernel by make menuconfig. :)
>>
>> Odd, this looks like a bug, Cc Catalin Marinas <catalin.marinas@arm.com>
>>
>> I can't reach my test machine right now, I will try this tomorrow.
>>
>
