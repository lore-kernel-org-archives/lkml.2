Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab2LRRtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:49:21 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:63320 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2LRRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:49:20 -0500
MIME-Version: 1.0
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
Date: Tue, 18 Dec 2012 09:49:18 -0800
X-Google-Sender-Auth: f-bs6z4bopmxail5WNe3MsgHT5w
Message-ID: <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
Subject: Re: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in
 MSR->x2apic enablement bit ?
From: Yinghai Lu <yinghai@kernel.org>
To: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 1:50 AM, Zhang, Lin-Bao (Linux Kernel R&D)
<linbao.zhang@hp.com> wrote:
> Hi Suresh and other guys ,
>
>         In 3.4.4/3.6.6 ,I found a x2apic issue . if I am wrong , sorry first , and welcome your correction . thanks for your forwarding other maintainers.
> I am testing a server , its BIOS is like this:
> a) If BIOS think the system is of x2apic , it will set x2apic enablement bit in MSR and create x2apic ACPI tables and pass control to OS with x2apic mode

kernel will check if DMAR table is right or not, if intr-remapping
could be enabled, kernel will stay with x2apic.
if intr-remapping can not be enabled (bad dmar table), kernel will
switch back to xapic mode, but if BSP's X2APIC is
bigger than 255, then you will get kernel panic.

> b) If BIOS feel the system doesn't meet x2apic conditions , it will not set x2apic enablement bit in MSR ,and pass control to OS with xapic mode.

kernel will check if cpuid support x2apic, if it supports x2apic, it
will check if DMAR/intr-remapping could be enabled, if so
kernel will switch to x2apic. otherwise it will stay with xapic.

So you need to make cpuid show does not support x2apic --- check with
intel they have way to do that.
or you can pass "nox2apic" in boot command line.

Yinghai
