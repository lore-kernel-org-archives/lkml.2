Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab2GFLNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:13:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37195 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2GFLNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:13:19 -0400
Date: Fri, 6 Jul 2012 13:13:14 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, mtosatti@redhat.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] apic: fix kvm build on UP without IOAPIC
Message-ID: <20120706111314.GG19552@gmail.com>
References: <20120701150506.GA31304@redhat.com>
 <4FF0849D.5080406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF0849D.5080406@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 07/01/2012 08:05 AM, Michael S. Tsirkin wrote:
> >On UP i386, when APIC is disabled
> ># CONFIG_X86_UP_APIC is not set
> ># CONFIG_PCI_IOAPIC is not set
> >
> >code looking at apicdrivers never has any effect but it
> >still gets compiled in. In particular, this causes
> >build failures with kvm, but it generally bloats the kernel
> >unnecessarily.
> >
> >Fix by defining both __apicdrivers and __apicdrivers_end
> >to be NULL when CONFIG_X86_LOCAL_APIC is unset: I verified
> >that as the result any loop scanning __apicdrivers gets optimized out by
> >the compiler.
> >
> >Warning: a .config with apic disabled doesn't seem to boot
> >for me (even without this patch). Still verifying why,
> >meanwhile this patch is compile-tested only.
> >
> >Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >---
> >
> >Note: if this patch makes sense, can x86 maintainers
> >please ACK applying it through the kvm tree, since that is
> >where we see the issue that it addresses?
> >Avi, Marcelo, maybe you can carry this in kvm/linux-next as a temporary
> >measure so that linux-next builds?
> >
> 
> I'm not happy about that as a workflow, but since you guys have an
> immediate problem I guess we can do that.

I'm rather unhappy about this workflow - we've got quite a few 
apic bits in the x86 tree this cycle as well and need extra 
external interaction, not.

Which KVM tree commit caused this, could someone please give a 
lkml link or quote it here? It's not referenced in the fix patch 
either.

Thanks,

	Ingo
