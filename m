Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab1CaLBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:01:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42164 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1CaLBT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:01:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Yu87x9jaCVS7l3GAfPTK40GlANc1Y7Wt/LBDSUzFUolVBAKnYzbBBZKAyJDI6wISeT
         QWEfCCPPf+A7SchXdhMIZ25sRm+LiVM9hl4hpHYZTDEz4fbJ+QzAbdcXkYaRPf3eaW4h
         OgkiXQU2mkQnDqiPOdKfZX/TPBM15Ohf9J3tY=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110331125305.1e8c70ba@schatten.dmk.lab>
References: <1301558489-4198-1-git-send-email-florian@mickler.org>
	<1301561386.1904.15.camel@t41.thuisdomein>
	<20110331125305.1e8c70ba@schatten.dmk.lab>
Date: Thu, 31 Mar 2011 13:01:18 +0200
Message-ID: <AANLkTikmWDu7FZ2A7_CWGCuAeKOeK4x+u8vctCro0mSN@mail.gmail.com>
Subject: Re: [PATCH][POKE] Skip looking for ioapic overrides when ioapics are
 not present
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Florian Mickler <florian@mickler.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, kurup_avinash@yahoo.com,
        maciej.rutecki@gmail.com, mingo@elte.hu, rjw@sisk.pl, zersaa@gmail.com,
        stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:53 PM, Florian Mickler <florian@mickler.org> wrote:
> On Thu, 31 Mar 2011 10:48:43 +0200
> Paul Bolle <pebolle@tiscali.nl> wrote:
>
>> On Thu, 2011-03-31 at 10:01 +0200, Florian Mickler wrote:
>> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> > index 68df09b..3940103 100644
>> > --- a/arch/x86/kernel/apic/io_apic.c
>> > +++ b/arch/x86/kernel/apic/io_apic.c
>> > @@ -3789,6 +3789,9 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>> >  {
>> >     int ioapic, pin, idx;
>> >
>> > +   if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>> > +           return -1;
>> > +
>> >     if (skip_ioapic_setup)
>> >             return -1;
>> >
>>
>> Seems to have the same goal as commit
>> 678301ecadec24ff77ab310eebf8a32ccddb1850 ("x86, ioapic: Don't warn about
>> non-existing IOAPICs if we have none"), which got merged in the v2.6.38
>> cycle (authored by me, signed off by Ingo Molnar). Maybe Eric's patch is
>> more correct. I can't say as I was happy with the effect of my patch
>> (ie, make an uninteresting error disappear) and didn't investigate any
>> further. I have also no desire to dive into this matter again.
>>
>>
>> Paul
>>
>
> Thanks for letting me know. Sedat, did you actually test with 2.6.38?
>
> Regards,
> Flo
>

I have and had this patch in my own patch-series *before* Debian
included it (IIRC right after Eric committed it to LKML).
To answer your question: Yes.
I have the patch also in my current linux-next kernels (next-20110331).

- Sedat -
