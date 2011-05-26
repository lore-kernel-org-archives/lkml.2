Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519Ab1EZU4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab1EZU4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:56:16 -0400
Date: Thu, 26 May 2011 16:55:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110526205549.GM29496@redhat.com>
References: <1306269105.21443.20.camel@dan>
 <20110526203502.GK29496@redhat.com>
 <20110526204030.GL29496@redhat.com>
 <1306442674.2279.29.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306442674.2279.29.camel@dan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 04:44:34PM -0400, Dan Rosenberg wrote:
> On Thu, 2011-05-26 at 16:40 -0400, Vivek Goyal wrote:
> > On Thu, May 26, 2011 at 04:35:02PM -0400, Vivek Goyal wrote:
> > > On Tue, May 24, 2011 at 04:31:45PM -0400, Dan Rosenberg wrote:
> > > > This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> > > > which the kernel is decompressed at boot as a security feature that
> > > > deters exploit attempts relying on knowledge of the location of kernel
> > > > internals.  The default values of the kptr_restrict and dmesg_restrict
> > > > sysctls are set to (1) when this is enabled, since hiding kernel
> > > > pointers is necessary to preserve the secrecy of the randomized base
> > > > address.
> > > 
> > > What happens to /proc/iomem interface which gives us the physical memory
> > > location where kernel is loaded. kexec-tools relies on that interface
> > > heavily so we can not take it away. And if we can not take it away then
> > > I think somebody should be easibly be able to calculate this randomized
> > > base address.
> 
> Is it common to run kexec-tools as non-root?  It may be necessary to
> restrict this interface to root when randomization is used (keep in mind
> nobody's going to force you to turn this on by default, at least for the
> foreseeable future).

kexec-tools runs as root. And I see that /proc/iomem permissions are
also for root only. So it probably is a non-issue.

Thanks
Vivek
