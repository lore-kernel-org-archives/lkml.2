Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1LMBaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:30:01 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56361 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1LMBaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <1323735902.1984.165.camel@sbsiddha-desk.sc.intel.com>
References: <4EE2BC33.80902@gmail.com>
	<CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	<20111211075713.GA20790@elte.hu>
	<CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
	<4EE5291C.1030302@gmail.com>
	<CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
	<4EE68C80.7000408@gmail.com>
	<1323735902.1984.165.camel@sbsiddha-desk.sc.intel.com>
Date: Mon, 12 Dec 2011 17:29:59 -0800
X-Google-Sender-Auth: Vcw5y2FUYPpBjlQlDdw8pax5K6g
Message-ID: <CAE9FiQW5GNTqgpFtV1JuOY51H4sUBCwLwJhJqxVtwksCFsdvHQ@mail.gmail.com>
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Berck E. Nash" <flyboy@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 4:25 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Mon, 2011-12-12 at 15:21 -0800, Berck E. Nash wrote:
>> On 12/11/2011 08:40 PM, Yinghai Lu wrote:
>> > x2apic pre-enabled skip the mapping for lapic address. so need map it
>> > after fall back.
>> >
>> > please check attached -v5..
>>
>> It appears to work correctly as far as I can tell.
>
> Ok. In this case, it looks like bios didn't enable interrupt-remapping
> (part of vt-d) and just enabled x2apic with out touching or exporting
> vt-d HW.
>
> Yinghai, In other scenarios where OS can't recover, mostly likely we
> will fail in check_timer() when we fall back to xapic. Can we add a
> printk in this case to convey the potential reason (that I mentioned in
> the previous e-mail), so that the user can get more accurate information
> for the check timer failure.

agree. in that case, will have problem.

but i don't think bios buy can go that far to enable intr-remapping
without providing DMAR.

will check if can add print out in check_timer() when
x2apic_preenabled == 1 and x2apic == 0...

Thanks

Yinghai Lu
