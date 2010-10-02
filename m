Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0JBOp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:45:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45490 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab0JBOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:45:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Avinash Kurup <kurup.avinash@gmail.com>
References: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com>
	<m17hmcke5m.fsf@fess.ebiederm.org> <4CA515AA.7060400@zytor.com>
Date: Sat, 02 Oct 2010 07:45:21 -0700
In-Reply-To: <4CA515AA.7060400@zytor.com> (H. Peter Anvin's message of "Thu,
	30 Sep 2010 15:56:42 -0700")
Message-ID: <m1k4m0lkla.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Skip looking for ioapic overrides when ioapics are not present
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 06/05/2010 08:56 PM, Eric W. Biederman wrote:
>> 
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 33f3563..226a6d1 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -4066,6 +4066,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>>  {
>>  	int ioapic, pin, idx;
>>  
>> +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>> +		return -1;
>> +
>>  	if (skip_ioapic_setup)
>>  		return -1;
>>  
>
> I was just poked about this patch... it doesn't build "make allnoconfig"
> on x86-64.
>
> This is also a bugzilla ticket now:
> https://bugzilla.kernel.org/show_bug.cgi?id=17772

That sucks.  Do we need to move this function into an acpi specific
file to pass allnonconfig?

Barring crazy build issues the fix is right.

I'm not certain when I will get a chance to look at build issues
as my load spiked considerably.

Eric
