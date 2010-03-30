Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0C3OtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:49:17 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:49033 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0C3OtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:49:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tez6gnFAZ5K/XldYlzcGahxEqf4UASDmDDld92WAipU6jsndiHR14E6DVZsLI/ZMCW
         PoJtM+i8j/dbqug2qrzvEeOMUcqQGq0pEcqR2R06aAjx/Fug4B1YXeP8nY90DKMq25qI
         zqJEfiXM3F0VOuWY1V58dh6NCyTDlm86X32UI=
MIME-Version: 1.0
In-Reply-To: <4BB20AAB.7000909@twiddle.net>
References: <1269913795-1852-1-git-send-email-mattst88@gmail.com>
	 <4BB20AAB.7000909@twiddle.net>
Date: Tue, 30 Mar 2010 10:49:13 -0400
Message-ID: <b4198de61003300749s7344f4f7o9070fafb142eb5b4@mail.gmail.com>
Subject: Re: [RFC] alpha: hack objstrip.c to make it compile.
From: Matt Turner <mattst88@gmail.com>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, ang@brigante.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 10:28 AM, Richard Henderson <rth@twiddle.net> wrote:
> On 03/29/2010 06:49 PM, Matt Turner wrote:
>> I don't think this is the appropriate fix. What should I do to fix this?
>> ---
>>  arch/alpha/boot/tools/objstrip.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
>> index 367d53d..54fa1ef 100644
>> --- a/arch/alpha/boot/tools/objstrip.c
>> +++ b/arch/alpha/boot/tools/objstrip.c
>> @@ -27,6 +27,9 @@
>>  #include <linux/param.h>
>>  #ifdef __ELF__
>>  # include <linux/elf.h>
>> +# define elfhdr      elf64_hdr
>> +# define elf_phdr    elf64_phdr
>> +# define elf_check_arch(x) ((x)->e_machine == EM_ALPHA)
>>  #endif
>>
>
> Hum.  Is it so bad to just #define __KERNEL__ here before
> that one include?  Similar games are played in tools/perf/,
> and with a suitible comment I think that should be all right.
>
>
> r~

The problem is that, at least with my distribution, probably others
too, the headers installed into /usr/include/linux/ are stripped of
anything inside #ifdef __KERNEL__.

Matt
