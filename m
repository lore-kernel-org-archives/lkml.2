Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0JROLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:11:04 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49427 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab0JROLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QWooJJ+d1cOoz6JJR2AZxlZSMLJJSRCKejDntz9P4X/NZb9YWbeMcFv/mj/fOMr+Tr
         fYNqCDMJxlYuU+jRAcEp9AKSBQ6/vXi80bk4Um/ieVpetFFD1/PZi1U+Pz4F1lvCM3NV
         E0wo+MS5oG5K2JkPDFwjqnnhcw/aH9Xi24ycc=
MIME-Version: 1.0
In-Reply-To: <4CBC547A.8080700@redhat.com>
References: <AANLkTin6qJYEqOc_97EVWkK1Kt1zNSvXtfVeYuk9fyJ8@mail.gmail.com>
	<4CBAE8E2.1060704@redhat.com>
	<AANLkTi=5yGPmZxZY7T_oeyJ4xS+RWt7cY4WD=78fbo7v@mail.gmail.com>
	<4CBBF3C8.9070104@web.de>
	<4CBC1047.6010501@redhat.com>
	<20101018125803.GA2497@darkstar>
	<4CBC4B06.3030300@redhat.com>
	<20101018134508.GA11885@darkstar>
	<4CBC4FA9.90406@redhat.com>
	<4CBC5097.1020105@redhat.com>
	<20101018135813.GA20316@darkstar>
	<4CBC547A.8080700@redhat.com>
Date: Mon, 18 Oct 2010 22:11:00 +0800
Message-ID: <AANLkTi=htiXrjAnQcm7=Rha+PYQA7iibn3WFRzyx_Owq@mail.gmail.com>
Subject: Re: [BUG] kvm: guest can not startup due to triple fault
From: Dave Young <hidave.darkstar@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Kiszka <jan.kiszka@web.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:06 PM, Avi Kivity <avi@redhat.com> wrote:
>  On 10/18/2010 03:58 PM, Dave Young wrote:
>>
>> >
>> >  Please patch hardware_setup() to show the value of
>> >  boot_cpu_has(X86_FEATURE_NX).
>>
>> It's 0

Please wait, I reply too quick, actually it boots two times fine then
one time fail.

The printk only happen once. So to make sure the result I retested
several times, can not get the print as well.

>
> Well, that's ridiculous.  Looking back at your /proc/cpuinfo:
>
>> processor       : 0
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall lm
>> constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi
>> flexpriority
>>
>> processor       : 1
>> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
>> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm
>> constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64 monitor
>> ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm lahf_lm ida dts tpr_shadow vnmi
>> flexpriority
>
> processor 0 doesn't have nx.
>
> Ingo, Peter, any ideas?  Where did the missing feature go?
>
> --
> error compiling committee.c: too many arguments to function
>
>



-- 
Regards
dave
