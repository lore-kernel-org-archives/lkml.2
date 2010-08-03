Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0HCXM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 19:12:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32949 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab0HCXM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 19:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=axp1KgO56I9r/Gb8hMXpB12rx70R69FteZr/7ZJa+48nWmOGWRUQNzBVlV3gSqnBpv
         kClALVpnZkK1K4DCpxlkauATZE8OXiLl72iWG443+5okN+wZKgPm2eI+TZcsOBcB6qVW
         vHVnj5/Shf3bVtqy9B3JllrWyPqfC9opRGiRo=
MIME-Version: 1.0
In-Reply-To: <m1bp9jgyww.fsf@fess.ebiederm.org>
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org>
	<4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org>
	<4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org>
	<4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org>
	<4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org>
	<4C57E32A.9070401@kernel.org>
	<m18w4onebi.fsf@fess.ebiederm.org>
	<4C5871BC.4070007@kernel.org>
	<m1bp9jgyww.fsf@fess.ebiederm.org>
Date: Wed, 4 Aug 2010 09:12:25 +1000
Message-ID: <AANLkTin-OmHiRK58d3j5jzESanvmLz2h+weXCEzb+Xxz@mail.gmail.com>
Subject: Re: oops in ioapic_write_entry
From: Dave Airlie <airlied@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 7:38 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On 08/03/2010 04:08 AM, Eric W. Biederman wrote:
>>>
>>> For the common case I think we still do the right thing, even now, for
>>> these broken bios tables.  There is likely an uncommon case for which
>>> something like your shared_legacy_irq deserves to be used, especially
>>> at it preserves our well tested historical behavior.
>>
>> Dave, Irnna, Gary:
>>
>> can you check this patch on your systems?
>
>
>
>>
>> Thanks
>>
>> Yinghai
>>
>> [PATCH] x86: check if apic/pin is shared with legacy one
>>
>> fix system that external device that have io apic on apic0/pin(0-15)
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Your patch addresses what appears to be a theoretical issue, caused by
> a BIOS bug.  So far you have not presented a credible scenario where
> this would affect anything in real life except the user visible irq
> number.
>
> Will you please stop, think, and describe what is going on clearly
> and how you expect this patch to affect anything, and please stop
> selling this patch as the solution to all of the world's ills.  You
> are being sloppy and wasting everyone's time.
>
> This patch definitely does not solve Dave Airlie's problem.  That was
> clearly caused by a (ACPI being disabled compared to the test case)
> and a bad BIOS provided MP table with an invalid apic_id, and our
> attempt to lookup the ioapic and failed.

Oh wow, I totally missed I had ACPI off on this build, I turned it off
a few kernels back to test the build didn't break, and forgot to turn
it back on.

So clearly my mptable is just busted and we can probably move along,
I'll rebuild/boot with ACPI now, and I think you can assume it works
fine unless I get back to you.

Thanks, and sorry for wasting time.

Dave.
