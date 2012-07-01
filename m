Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2GARLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:11:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2GARLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:11:10 -0400
Message-ID: <4FF0849D.5080406@zytor.com>
Date: Sun, 01 Jul 2012 10:10:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mtosatti@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] apic: fix kvm build on UP without IOAPIC
References: <20120701150506.GA31304@redhat.com>
In-Reply-To: <20120701150506.GA31304@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 08:05 AM, Michael S. Tsirkin wrote:
> On UP i386, when APIC is disabled
> # CONFIG_X86_UP_APIC is not set
> # CONFIG_PCI_IOAPIC is not set
>
> code looking at apicdrivers never has any effect but it
> still gets compiled in. In particular, this causes
> build failures with kvm, but it generally bloats the kernel
> unnecessarily.
>
> Fix by defining both __apicdrivers and __apicdrivers_end
> to be NULL when CONFIG_X86_LOCAL_APIC is unset: I verified
> that as the result any loop scanning __apicdrivers gets optimized out by
> the compiler.
>
> Warning: a .config with apic disabled doesn't seem to boot
> for me (even without this patch). Still verifying why,
> meanwhile this patch is compile-tested only.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Note: if this patch makes sense, can x86 maintainers
> please ACK applying it through the kvm tree, since that is
> where we see the issue that it addresses?
> Avi, Marcelo, maybe you can carry this in kvm/linux-next as a temporary
> measure so that linux-next builds?
>

I'm not happy about that as a workflow, but since you guys have an 
immediate problem I guess we can do that.


Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.



