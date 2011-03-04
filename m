Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab1CDBmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 20:42:00 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59853 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab1CDBl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 20:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QFVMi70jTwMimMXf2r7Hm3P6Eea75Tts+uopwawWOl5MS4uitUS8urW4QPHTUtz3gA
         p1o23pumOECa0MAWweO7jO1tjRKNjKLW72SD39R78ZG6dsm/HTVDRBV1loujnkrNjRFU
         DNLuvPYJZlBdXf/khz4tCFzAERSKJx6Z5WmIs=
MIME-Version: 1.0
In-Reply-To: <20110303145908.GA32154@redhat.com>
References: <20110303135819.GA2620@darkstar>
	<20110303145908.GA32154@redhat.com>
Date: Fri, 4 Mar 2011 09:41:59 +0800
Message-ID: <AANLkTi=sz7By1HaJ+HhFaQDWyUnrR5PNyAcL0uPnEt-K@mail.gmail.com>
Subject: Re: [PATCH 01/05] use proc_dointvec_minmax to check boundaries while needed
From: Dave Young <hidave.darkstar@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p241g6xM030010

On Thu, Mar 3, 2011 at 10:59 PM, Don Zickus <dzickus@redhat.com> wrote:
> On Thu, Mar 03, 2011 at 09:58:20PM +0800, Dave Young wrote:
>> proc_dointvec doesn't check extra minmax params, use proc_dointvec_minmax
>> instead of proc_dointvec for cases need boundaries check.
>
> Is this patch needed, if you are basically changing it again in patches 3
> and 5?

Sure if 3 and 5 is acked, if someone object them then this is good?

>
> Cheers,
> Don
>
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> ---
>>  kernel/sysctl.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> --- linux-2.6.orig/kernel/sysctl.c    2011-03-03 10:44:53.000000000 +0800
>> +++ linux-2.6/kernel/sysctl.c 2011-03-03 11:02:43.736663258 +0800
>> @@ -374,7 +374,7 @@ static struct ctl_table kern_table[] = {
>>               .data           = &sysctl_sched_autogroup_enabled,
>>               .maxlen         = sizeof(unsigned int),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>               .extra2         = &one,
>>       },
>> @@ -1204,7 +1204,7 @@ static struct ctl_table vm_table[] = {
>>               .data           = &block_dump,
>>               .maxlen         = sizeof(block_dump),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>       },
>>       {
>> @@ -1212,7 +1212,7 @@ static struct ctl_table vm_table[] = {
>>               .data           = &sysctl_vfs_cache_pressure,
>>               .maxlen         = sizeof(sysctl_vfs_cache_pressure),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>       },
>>  #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
>> @@ -1221,7 +1221,7 @@ static struct ctl_table vm_table[] = {
>>               .data           = &sysctl_legacy_va_layout,
>>               .maxlen         = sizeof(sysctl_legacy_va_layout),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>       },
>>  #endif
>> @@ -1231,7 +1231,7 @@ static struct ctl_table vm_table[] = {
>>               .data           = &zone_reclaim_mode,
>>               .maxlen         = sizeof(zone_reclaim_mode),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>       },
>>       {
>> @@ -1287,7 +1287,7 @@ static struct ctl_table vm_table[] = {
>>               .data           = &vdso_enabled,
>>               .maxlen         = sizeof(vdso_enabled),
>>               .mode           = 0644,
>> -             .proc_handler   = proc_dointvec,
>> +             .proc_handler   = proc_dointvec_minmax,
>>               .extra1         = &zero,
>>       },
>>  #endif
>



-- 
Regards
dave
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
