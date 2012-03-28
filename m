Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2C1SVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:21:45 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43662 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab2C1SVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:21:43 -0400
Message-ID: <4F73568D.7000703@linux.vnet.ibm.com>
Date: Wed, 28 Mar 2012 23:51:01 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Meadows <alan.meadows@gmail.com>, Avi Kivity <avi@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: Re: [PATCH RFC V6 0/11] Paravirtualized ticketlocks
References: <20120321102041.473.61069.sendpatchset@codeblue.in.ibm.com> <4F707C5F.1000905@redhat.com>	<4F716E31.3000803@linux.vnet.ibm.com> <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com>
In-Reply-To: <CAMy5W3foop40+R1RLv_JPhnO5ZmV90uMmNERYY-e3QCeaJfqLw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12032818-9574-0000-0000-0000020295C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 09:39 PM, Alan Meadows wrote:
> I am happy to see this issue receiving some attention and second the
> wish to see these patches be considered for further review and inclusion
> in an upcoming release.
>
> Overcommit is not as common in enterprise and single-tenant virtualized
> environments as it is in multi-tenant environments, and frankly we have
> been suffering.
>
> We have been running an early copy of these patches in our lab and in a
> small production node sample set both on3.2.0-rc4 and 3.3.0-rc6 for over
> two weeks now with great success. With the heavy level of vCPU:pCPU
> overcommit required for our situation, the patches are increasing
> performance by an _order of magnitude_ on our E5645 and E5620 systems.
>

Thanks Alan for the support. I feel timing of this patch was little bad
though. (merge window)

>
>
>         Looks like a good baseline on which to build the KVM
>         implementation.  We
>         might need some handshake to prevent interference on the host
>         side with
>         the PLE code.
>

I think I still missed some point in Avi's comment. I agree that PLE
may be interfering with above patches (resulting in less performance
advantages). but we have not seen performance degradation with the
patches in earlier benchmarks. [ theoretically since patch has very
slight advantage over PLE that atleast it knows who should run next ].

So TODO in my list on this is:
1. More analysis of performance on PLE mc.
2. Seeing how to implement handshake to increase performance (if PLE +
patch combination have slight negative effect).

Sorry that, I could not do more analysis on PLE (as promised last time)
because of machine availability.

I 'll do some work on this and comeback. But in the meantime, I do not
see it as blocking for next merge window.

>
>     Avi, Thanks for reviewing. True, it is sort of equivalent to PLE on
>     non PLE machine.
>
>     Ingo, Peter,
>     Can you please let us know if this series can be considered for next
>     merge window?
>     OR do you still have some concerns that needs addressing.
>
>     I shall rebase patches to 3.3 and resend. (main difference would be
>     UNINLINE_SPIN_UNLOCK and jump label changes to use
>     static_key_true/false() usage instead of static_branch.)

