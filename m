Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2LSQFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:05:48 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:63668 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab2LSQFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
	<CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
	<92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net>
Date: Wed, 19 Dec 2012 08:05:38 -0800
X-Google-Sender-Auth: 3FNOQmzd_UQTSRAVJPnEA97BFi8
Message-ID: <CAE9FiQVAPnc7P91AK8gdwgY-xFsXMM_MxYZAu2sRjsp3EdA96w@mail.gmail.com>
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

On Wed, Dec 19, 2012 at 2:36 AM, Zhang, Lin-Bao (Linux Kernel R&D)
<linbao.zhang@hp.com> wrote:
> Hi Yinghai ,
>
> Actually ,my question like this:
> OS can really enable x2apic correctly without BIOS' help in this case :
> BIOS has claimed definitely it doesn't enable x2apic ,but OS feel it can enable x2apic(based on BSP supports x2apic) ).

how does BIOS cleaim?

disable that in CPUID?

>
> If Linux don't need BIOS' help , how did linux kernel reach this action?

need DMAR table to enable intr remapping.
--- ioapic only have 8 bits for dst.
