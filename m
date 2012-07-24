Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2GXLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 07:09:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:35350 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2GXLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 07:09:57 -0400
Message-ID: <500E8280.6050905@parallels.com>
Date: Tue, 24 Jul 2012 15:09:52 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com> <500E4960.8040307@parallels.com> <500E5951.5020900@amd.com> <500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com>
In-Reply-To: <20120724101041.GA24739@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 02:10 PM, Borislav Petkov wrote:
> On Tue, Jul 24, 2012 at 12:29:19PM +0400, Vladimir Davydov wrote:
>> I guess that when the more advanced features become widely-used,
>> vendors will offer new MSRs and/or CPUID faulting.
> And this right there is the dealbreaker:
>
> So what are you doing for cpus which have the advanced CPUID features
> leafs but there are no MSRs to turn those bits off?

We have not encountered this situation in our environments and I hope we 
won't :-)

But look, these CPUID functions cover majority of CPU features, don't 
they? So, most of "normal" apps inside VM will survive migration. 
Perhaps, some low-level utils won't. I guess that's why there are no 
MSRs for other levels provided by vendors.

> You surely need some software-only solution for the migration to work,
> no?

Yes.

> If so, why not apply that solution to your hypervisor without touching
> the kernel at all?

In most hypervisor-based virtualization products, this is already 
implemented using VMM-exits, so that each VM can have arbitrary CPUID 
mask set by the admin.

The problem is that we have no hypervisor. "Virtualization" we want this 
feature for is based on cgroups and namespaces (examples are OpenVZ and 
mainstream LXC). Tasks are just grouped into virtual environments and 
share the same kernel, which is proved to be more memory usage efficient 
than traditional hypervisor-based approaches.

> Thanks.
>

