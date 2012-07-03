Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab2GCSz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2GCSzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:55:54 -0400
Date: Tue, 3 Jul 2012 15:55:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] apic: fix kvm build on UP without IOAPIC
Message-ID: <20120703185511.GA24415@amt.cnet>
References: <20120701150506.GA31304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701150506.GA31304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 06:05:06PM +0300, Michael S. Tsirkin wrote:
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

Applied, thanks.

