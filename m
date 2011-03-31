Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1CaMFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:05:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42275 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1CaMFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:05:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: sedat.dilek@gmail.com
Cc: Florian Mickler <florian@mickler.org>, Paul Bolle <pebolle@tiscali.nl>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kurup_avinash@yahoo.com, maciej.rutecki@gmail.com, mingo@elte.hu,
        rjw@sisk.pl, zersaa@gmail.com, stable@kernel.org
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are not present
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
	<20110331125305.1e8c70ba@schatten.dmk.lab>
	<AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
Date: Thu, 31 Mar 2011 05:05:30 -0700
In-Reply-To: <AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
	(Sedat Dilek's message of "Thu, 31 Mar 2011 13:01:18 +0200")
Message-ID: <m1ipuzfqb9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19WdcOYRk6V5SiasYUdaG4ZW9+RbYwLSM4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sedat Dilek <sedat.dilek@googlemail.com> writes:

> On Thu, Mar 31, 2011 at 12:53 PM, Florian Mickler <florian@mickler.org> wrote:
>> On Thu, 31 Mar 2011 10:48:43 +0200
>> Paul Bolle <pebolle@tiscali.nl> wrote:
>>
>>> On Thu, 2011-03-31 at 10:01 +0200, Florian Mickler wrote:
>>> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>>> > index 68df09b..3940103 100644
>>> > --- a/arch/x86/kernel/apic/io_apic.c
>>> > +++ b/arch/x86/kernel/apic/io_apic.c
>>> > @@ -3789,6 +3789,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>>> >  {
>>> >     int ioapic, pin, idx;
>>> >
>>> > +   if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>>> > +           return -1;
>>> > +
>>> >     if (skip_ioapic_setup)
>>> >             return -1;
>>> >
>>>
>>> Seems to have the same goal as commit
>>> 678301ecadec24ff77ab310eebf8a32ccddb1850 ("x86, ioapic: Don't warn about
>>> non-existing IOAPICs if we have none"), which got merged in the v2.6.38
>>> cycle (authored by me, signed off by Ingo Molnar). Maybe Eric's patch is
>>> more correct. I can't say as I was happy with the effect of my patch
>>> (ie, make an uninteresting error disappear) and didn't investigate any
>>> further. I have also no desire to dive into this matter again.

Yes. My patch is more correct.  We really do want the warning if we have
0 ioapics and we expect to be using ioapics.  It doesn't make sense to
suppress the warning unless we aren't in ioapic mode.

I don't have a clue why my patch got lost, but can we please get it
applied?

>> Thanks for letting me know. Sedat, did you actually test with 2.6.38?
>>
>> Regards,
>> Flo

> I have and had this patch in my own patch-series *before* Debian
> included it (IIRC right after Eric committed it to LKML).
> To answer your question: Yes.
> I have the patch also in my current linux-next kernels
> (next-20110331).

Eric
