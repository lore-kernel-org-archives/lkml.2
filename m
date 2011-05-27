Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1E0NVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:21:46 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:60505 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1E0NVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:21:43 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <20110527131313.GB8053@redhat.com>
References: <1306269105.21443.20.camel@dan>
	 <20110526203502.GK29496@redhat.com> <20110526204030.GL29496@redhat.com>
	 <1306442674.2279.29.camel@dan>  <20110527131313.GB8053@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 09:21:32 -0400
Message-ID: <1306502492.3339.2.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 09:13 -0400, Vivek Goyal wrote:
> On Thu, May 26, 2011 at 04:44:34PM -0400, Dan Rosenberg wrote:
> > On Thu, 2011-05-26 at 16:40 -0400, Vivek Goyal wrote:
> > > On Thu, May 26, 2011 at 04:35:02PM -0400, Vivek Goyal wrote:
> > > > On Tue, May 24, 2011 at 04:31:45PM -0400, Dan Rosenberg wrote:
> > > > > This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> > > > > which the kernel is decompressed at boot as a security feature that
> > > > > deters exploit attempts relying on knowledge of the location of kernel
> > > > > internals.  The default values of the kptr_restrict and dmesg_restrict
> > > > > sysctls are set to (1) when this is enabled, since hiding kernel
> > > > > pointers is necessary to preserve the secrecy of the randomized base
> > > > > address.
> > > > 
> > > > What happens to /proc/iomem interface which gives us the physical memory
> > > > location where kernel is loaded. kexec-tools relies on that interface
> > > > heavily so we can not take it away. And if we can not take it away then
> > > > I think somebody should be easibly be able to calculate this randomized
> > > > base address.
> > 
> > Is it common to run kexec-tools as non-root?  It may be necessary to
> > restrict this interface to root when randomization is used (keep in mind
> > nobody's going to force you to turn this on by default, at least for the
> > foreseeable future).
> 
> Dan, 
> 
> I had a stupid question. /proc/kallsyms is also readable by root only. So
> if we are doing this so that non-root user can not know kernel virtual and
> physical address that should be already covered as non-root users can't
> read /proc/kallsysm or /boot/System.map.
> 

Not sure what system you're running, but /proc/kallsyms is 0444 on my
machine (and in mainline, afaik).  Likewise for /proc/iomem.

The problem is mainly with distribution kernels - it's trivial to just
grab an identical vmlinux to a target machine and then you instantly
know exactly where everything is.

> And if this randomization is also to protect information from root user
> then /proc/iomem exporting the physical address of kernel is still a
> valid question in that context.
> 

I think we can deal with unprivileged users first, and if we want to
truly prevent root from finding this out, we can introduce a separate
toggle that locks things down further.

-Dan

> Thanks
> Vivek


