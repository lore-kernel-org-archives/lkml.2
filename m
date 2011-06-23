Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1FWPHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:07:02 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:36282 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758983Ab1FWPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:07:00 -0400
Date: Thu, 23 Jun 2011 16:05:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Martyn Welch <martyn.welch@ge.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-am33-list@redhat.com,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org Tony Luck" <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing
 PAGE_KERNEL_NOCACHE
Message-ID: <20110623150557.GA9258@linux-mips.org>
References: <20110623114536.GA14011@linux-mips.org>
 <4E032940.5010205@ge.com>
 <20110623120234.GA22524@linux-mips.org>
 <8B77EED3-D197-4AB9-9594-278DB7002D6D@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8B77EED3-D197-4AB9-9594-278DB7002D6D@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 07:10:29AM -0500, Kumar Gala wrote:

> > (Adding the PPC folks to cc.)
> > 
> > A "git grep -w PAGE_KERNEL_NOCACHE arch/powerpc/" doesn't find anything so
> > I don't think the driver will build there.  I don't have a PPC toolchain
> > to verify that.
> 
> I can verify it fails on PPC as well:
> 
> drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
> drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
> drivers/staging/comedi/drivers.c:505:37: note: each undeclared identifier is reported only once for each function it appears in
> 
> However, we do have a #define for PAGE_KERNEL_NC.

Do you think this driver in it's current stage is so valuable that some
ifdefery to get it to work on PPC is the way to go?

IA-64 has PAGE_KERNEL_UC, so basically the same question for IA-64, too.

But preferably the driver should be sorted out properly and until the v1
of my patch which disables it on all architectures that don't provide a
PAGE_KERNEL_NOCACHE definition will do just fine.

  Ralf
