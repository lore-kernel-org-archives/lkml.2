Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0LQVAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 16:00:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51952 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab0LQVAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 16:00:10 -0500
Message-ID: <4D0BCF32.8060400@zytor.com>
Date: Fri, 17 Dec 2010 12:59:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <20101217170146.GC9568@redhat.com> <4D0BA45A.7020402@zytor.com> <20101217180242.GB12425@redhat.com> <4D0BAA24.3080801@kernel.org> <4D0BBC55.4010207@zytor.com> <4D0BBE00.3010602@kernel.org> <20101217195035.GE14502@redhat.com> <4D0BC067.90507@zytor.com> <20101217201104.GG14502@redhat.com>
In-Reply-To: <20101217201104.GG14502@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 12:11 PM, Vivek Goyal wrote:
>>
>> Can we do this in the meantime, just so we fix the immediate problem?
> 
> Peter, kexec-tools on 64bit currently seems to be allowing loding bzImage
> till 896MB. So I am not too keen it to reduce it to 768MB in kernel just
> because x86_64 could be booted from even higher addresses and somebody
> first has to do some auditing and experiments.
> 
> IMHO, we should have 768MB limit for 32bit and continue with 896MB limit for
> 64bit and once somebody makes x86_64 boot from even higher address reliably
> then we can change both kernel and kexec-tools.
> 

If we're splitting by architectures anyway, why not leave 32 bits at 512
MiB and thus making older crashkernels usable just in case someone has a
frozen toolset?

	-hpa
