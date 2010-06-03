Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab0FCJId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 05:08:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60730 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab0FCJIa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 05:08:30 -0400
To: Avinash Kurup <kurup.avinash@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 03 Jun 2010 02:08:23 -0700
In-Reply-To: <AANLkTilT0cPU8y2m4ZeatfvtflAagSyQEP9JubqZ6TeW@mail.gmail.com> (Avinash Kurup's message of "Thu\, 3 Jun 2010 13\:59\:15 +0530")
Message-ID: <m1zkzcpjp4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: kurup.avinash@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Avinash Kurup <kurup.avinash@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: ERROR: Unable to locate IOAPIC for GSI xx
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avinash Kurup <kurup.avinash@gmail.com> writes:

> Hi Eric,
>     I get the following errors while booting into 2.6.35-rc1. I did not
> get these in 2.6.34 . The computer however boots and works fine, So its not
> serious but the following errors are displayed in dmesg.
>
> [    0.089969] ERROR: Unable to locate IOAPIC for GSI 13
> [    0.090556] ERROR: Unable to locate IOAPIC for GSI 8
> [    0.091104] ERROR: Unable to locate IOAPIC for GSI 12
> [    0.091375] ERROR: Unable to locate IOAPIC for GSI 1
> [    0.093195] ERROR: Unable to locate IOAPIC for GSI 4
> [    0.094342] ERROR: Unable to locate IOAPIC for GSI 10
> [    0.096335] ERROR: Unable to locate IOAPIC for GSI 6
>
>     I bisected the problem to this commit.

Can I get a full boot log?

It sounds like this would easily be triggered by one of my patches, I
am dubious about the particular patch you point out.  As that only
adds a new function but does not call it.

There should be boot lines that say something like:

> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: IOAPIC (id[0x05] address[0xdfefc000] gsi_base[24])
> [    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xdfefc000, GSI 24-47
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ9 used by override.

I would like to look at those because they should tell the story of why
you can not find an IOAPIC for your GSIs.

It is possible that the explanation will simply be that the bug I fixed
made those GSIs usable (to linux) on your platform for the first time.

What hardware are you seeing this on?

Eric
