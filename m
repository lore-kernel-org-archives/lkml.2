Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab0CPXCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175Ab0CPXC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:02:28 -0400
Message-ID: <4BA00DE5.80604@redhat.com>
Date: Tue, 16 Mar 2010 19:01:57 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: oerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       sungho.kim.zd@hitachi.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <4B9F19F7.6000309@redhat.com> <20100316072449.GB11881@elte.hu> <4B9F4D74.4090403@redhat.com> <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <20100316223040.GH13108@8bytes.org>
In-Reply-To: <20100316223040.GH13108@8bytes.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oerg Roedel wrote:
> On Tue, Mar 16, 2010 at 12:25:00PM +0100, Ingo Molnar wrote:
>> Hm, that sounds rather messy if we want to use it to basically expose kernel 
>> functionality in a guest/host unified way. Is the qemu process discoverable in 
>> some secure way? Can we trust it? Is there some proper tooling available to do 
>> it, or do we have to push it through 2-3 packages to get such a useful feature 
>> done?
> 
> Since we want to implement a pmu usable for the guest anyway why we
> don't just use a guests perf to get all information we want? If we get a
> pmu-nmi from the guest we just re-inject it to the guest and perf in the
> guest gives us all information we wand including kernel and userspace
> symbols, stack traces, and so on.

I guess this aims to get information from old environments running on
kvm for life extension :)

> In the previous thread we discussed about a direct trace channel between
> guest and host kernel (which can be used for ftrace events for example).
> This channel could be used to transport this information to the host
> kernel.

Interesting! I know the people who are trying to do that with systemtap.
See, http://vesper.sourceforge.net/

> 
> The only additional feature needed is a way for the host to start a perf
> instance in the guest.

# ssh localguest perf record --host-chanel ... ? B-)

Thank you,

> 
> Opinions?
> 
> 
> 	Joerg
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
