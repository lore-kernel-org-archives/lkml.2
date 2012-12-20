Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2LTQtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 11:49:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54554 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab2LTQtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 11:49:08 -0500
Message-ID: <50D3415F.8010205@zytor.com>
Date: Thu, 20 Dec 2012 08:48:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Zhang, Lin-Bao (Linux Kernel R&D)" <linbao.zhang@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "jarkko.sakkinen@intel.com" <jarkko.sakkinen@intel.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        "agordeev@redhat.com" <agordeev@redhat.com>
Subject: Re: Why Linux kernel forced to enter X2APIC mode( just because of
 booting cpu has supported x2apic) without depending on BIOS' setting in MSR->x2apic
 enablement bit ?
References: <92645B27BF79D04FBD2B0F8494FFD0F91F1CAF@G1W3649.americas.hpqcorp.net> <CAE9FiQUT0NZq=6JBAY4mFNx0eBxDr6fNDGQ0GW9OtxUMXJQ21w@mail.gmail.com> <92645B27BF79D04FBD2B0F8494FFD0F91F2222@G1W3649.americas.hpqcorp.net> <CAE9FiQVAPnc7P91AK8gdwgY-xFsXMM_MxYZAu2sRjsp3EdA96w@mail.gmail.com> <92645B27BF79D04FBD2B0F8494FFD0F91F2600@G1W3649.americas.hpqcorp.net> <CAE9FiQVRcGvaTJ6NrxnQuFbPT9OwB7j8xxhDe5kcYUpgAMkz1A@mail.gmail.com>
In-Reply-To: <CAE9FiQVRcGvaTJ6NrxnQuFbPT9OwB7j8xxhDe5kcYUpgAMkz1A@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 08:46 AM, Yinghai Lu wrote:
> On Thu, Dec 20, 2012 at 2:38 AM, Zhang, Lin-Bao (Linux Kernel R&D)
> <linbao.zhang@hp.com> wrote:
>> I think current core argument is our BIOS did following judgement ,
>> but Linux kernel did not(Linux seems just judge BSP supports x2apic mode or not by CPUID method)
> 
> kernel checks that, if the BSP in x2apic mode, kernel will check if
> intr-remapping can be enabled, otherwise
> it will switch back to xapic mode.
> 
>> Our BSP really supports x2apic mode, however,as this spec, our BIOS think some of configuration of server
>> could not meet x2apic conditions ,So didn't place local xAPICs into x2apic mode.
>> But linux kernel indeed enable x2apic mode(just believe BSP, didn't do above judgement) . so this is the conflict.
> 
> so your BIOS is wrong,  it does not enable intr-remapping.
> 

FWIW, I bought a *server* today and it didn't have interrupt remapping
and x2APIC, I would consider it defective and return it.

	-hpa


