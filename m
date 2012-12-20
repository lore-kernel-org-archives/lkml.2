Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2LTQrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:47:13 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59055 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2LTQrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:47:02 -0500
MIME-Version: 1.0
In-Reply-To: <92645B27BF79D04FBD2B0F8494FFD0F91F2600@G1W3649.americas.hpqcorp.net>
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net>
	<CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com>
	<92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net>
	<CAE9FiQVAPnc7P91AK8gdwgY-xFsXMM_MxYZAu2sRjsp3EdA96w@mail.gmail.com>
	<92645B27BF79D04FBD2B0F8494FFD0F91F2600@G1W3649.americas.hpqcorp.net>
Date: Thu, 20 Dec 2012 08:46:59 -0800
X-Google-Sender-Auth: q7oMXTh1dJTT0vfKeANF2KMKSE4
Message-ID: <CAE9FiQVRcGvaTJ6NrxnQuFbPT9OwB7j8xxhDe5kcYUpgAMkz1A@mail.gmail.com>
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

On Thu, Dec 20, 2012 at 2:38 AM, Zhang, Lin-Bao (Linux Kernel R&D)
<linbao.zhang@hp.com> wrote:
> I think current core argument is our BIOS did following judgement ,
> but Linux kernel did not(Linux seems just judge BSP supports x2apic mode or not by CPUID method)

kernel checks that, if the BSP in x2apic mode, kernel will check if
intr-remapping can be enabled, otherwise
it will switch back to xapic mode.

> Our BSP really supports x2apic mode, however,as this spec, our BIOS think some of configuration of server
> could not meet x2apic conditions ,So didn't place local xAPICs into x2apic mode.
> But linux kernel indeed enable x2apic mode(just believe BSP, didn't do above judgement) . so this is the conflict.

so your BIOS is wrong,  it does not enable intr-remapping.

Yinghai
