Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab1I3Rf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:35:58 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:43147 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754433Ab1I3Rf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:35:56 -0400
Message-ID: <4E85FDF9.7060502@xenotime.net>
Date: Fri, 30 Sep 2011 10:35:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu >> \"Liu, Jinsong\"" <jinsong.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH] KVM: x86: Use do_div for tsc deadline calculation
References: <20110929165730.661cf28c9bb27b8a85432cd2@canb.auug.org.au> <4E84CC00.8090702@xenotime.net> <20110930085810.11bc8e2e38e1400a8b0b4cec@canb.auug.org.au> <4E85ACFC.1090509@siemens.com>
In-Reply-To: <4E85ACFC.1090509@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/11 04:50, Jan Kiszka wrote:
> Required on i386 hosts.
> 
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/kvm/lapic.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index f9385ec..92390dc 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -740,9 +740,10 @@ static void start_apic_timer(struct kvm_lapic *apic)
>  
>  		now = apic->lapic_timer.timer.base->get_time();
>  		guest_tsc = kvm_x86_ops->read_l1_tsc(vcpu);
> -		if (likely(tscdeadline > guest_tsc))
> -			ns = (tscdeadline - guest_tsc)
> -				* 1000000L / this_tsc_khz;
> +		if (likely(tscdeadline > guest_tsc)) {
> +			ns = (tscdeadline - guest_tsc) * 1000000ULL;
> +			do_div(ns, this_tsc_khz);
> +		}
>  		hrtimer_start(&apic->lapic_timer.timer,
>  			ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
