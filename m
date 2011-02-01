Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1BAID4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:03:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48193 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1BAIDz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZCkC+oN5ZHd03xeqNVzjFdVDhWTKwA8QRdqkSjskl96XXF79P0e1mzpvTn4hNBR72D
         77IA2nMzQmNlkT6GhEe7m/kYC89Mxkqggbv14LqAkxT7dJIx250ctSjMy1IU7wZgZTKj
         GVMf6YQ16exDa0UQEJ2dgvFgDKyZyw4RMqPJw=
MIME-Version: 1.0
In-Reply-To: <1db705ac90529708ef559eee9708b648@mail.gmail.com>
References: <1296496389-30647-1-git-send-email-will.deacon@arm.com>
	<1db705ac90529708ef559eee9708b648@mail.gmail.com>
Date: Tue, 1 Feb 2011 16:03:54 +0800
Message-ID: <AANLkTimBTrqOk_ctBKmT0c=teZ8oG3c7Ai6-BmZwOj+g@mail.gmail.com>
Subject: Re: [PATCH v2] oprofile: add SMP barriers for hrtimer hotplug code
From: Ming Lei <tom.leiming@gmail.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        oprofile-list@lists.sf.net, Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/2/1 Santosh Shilimkar <santosh.shilimkar@ti.com>:
>> -----Original Message-----
>> From: Will Deacon [mailto:will.deacon@arm.com]
>> diff --git a/drivers/oprofile/timer_int.c
>> b/drivers/oprofile/timer_int.c
>> index 0107251..a3a94ea 100644
>> --- a/drivers/oprofile/timer_int.c
>> +++ b/drivers/oprofile/timer_int.c
>> @@ -48,6 +48,7 @@ static int oprofile_hrtimer_start(void)
>>  {
>>       get_online_cpus();
>>       ctr_running = 1;
>> +     smp_mb();
>>       on_each_cpu(__oprofile_hrtimer_start, NULL, 1);

Just a little question:

Before calling __oprofile_hrtimer_start in other CPUs,
there have been some smp_mb executed already, such as called by
smp_call_function_many in current CPU, and called by
generic_smp_call_function_interrupt in the func-calling CPU,
so are these smp_mb enough for correct order of access
for 'ctr_running' ?

>>       put_online_cpus();
>>       return 0;

thanks,
-- 
Lei Ming
