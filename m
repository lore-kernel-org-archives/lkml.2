Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934774Ab0HDUey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:34:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48485 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934552Ab0HDUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:34:48 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>
	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>
	<m1bp9jgyww.fsf@fess.ebiederm.org> <4C592BF5.3070008@kernel.org>
	<m1mxt28tku.fsf@fess.ebiederm.org> <4C59BE0D.7020604@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Aug 2010 13:34:35 -0700
In-Reply-To: <4C59BE0D.7020604@kernel.org> (Yinghai Lu's message of "Wed\, 04 Aug 2010 12\:22\:53 -0700")
Message-ID: <m162zq86ck.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/04/2010 05:12 AM, Eric W. Biederman wrote:
>
>
>> 
>> In practice your test of looking at mp_bus_not_pci is essentially what
>> we do.  I wonder if it could be made to be a test of polarity and edge
>> mismatch instead.
>> 
>
> Dave's system mptable pol and trig is wrong ...

The are inconsistent.  Everything is set to the default for the bus.

> Int: type 0, pol 0, trig 0, bus 0a, IRQ 00, APIC ID 8, APIC INT 00
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 01, APIC ID 8, APIC INT 01
> Int: type 3, pol 1, trig 1, bus 0a, IRQ 00, APIC ID 8, APIC INT 02
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 03, APIC ID 8, APIC INT 03
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 04, APIC ID 8, APIC INT 04
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 05, APIC ID 8, APIC INT 05
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 06, APIC ID 8, APIC INT 06
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 07, APIC ID 8, APIC INT 07
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 08, APIC ID 8, APIC INT 08
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 09, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 0a, APIC ID 8, APIC INT 0a
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 0b, APIC ID 8, APIC INT 0b
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 0c, APIC ID 8, APIC INT 0c
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 0e, APIC ID 8, APIC INT 0e
> Int: type 0, pol 0, trig 0, bus 0a, IRQ 0f, APIC ID 8, APIC INT 0f
> Int: type 0, pol 0, trig 0, bus 00, IRQ 28, APIC ID 8, APIC INT 09
> Int: type 0, pol 0, trig 0, bus 00, IRQ 2c, APIC ID 8, APIC INT 0a
> Int: type 0, pol 0, trig 0, bus 00, IRQ 2d, APIC ID 8, APIC INT 0a
> Int: type 0, pol 0, trig 0, bus 00, IRQ 34, APIC ID 8, APIC INT 0e
> Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
> Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
> Int: type 0, pol 0, trig 0, bus 00, IRQ 38, APIC ID 8, APIC INT 0b
>
> Do you mean check pol/trig in addition to bus in this case?

No.  I was thinking it would be nice if we could check the
polarity and the irq trigger mode in this case.  Unfortunately
I don't think we have access to everything thing we need to perform
that check this early.

Eric
