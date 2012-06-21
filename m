Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab2FUPxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 11:53:33 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:55578 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2FUPxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 11:53:32 -0400
Date: Thu, 21 Jun 2012 17:53:27 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
Message-ID: <20120621155327.GZ25226@axis.com>
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com> <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 02:06:55AM +0200, Bjorn Helgaas wrote:
> On Mon, Jun 18, 2012 at 4:34 AM, Jan Beulich <JBeulich@suse.com> wrote:
> > DMI tables referenced from __init code only can be __initconst, and as
> > a result the functions referenced from there can become __init.
> >
> > pcibios_setup() can be __init as being a command line parsing function
> > only.
> >
> > A few other variables can then also have their attributes adjusted.
> 
> This seems OK as far as it goes.
> 
> However, if you're going to make pcibios_setup() __init for x86, I'd
> really encourage you to make it consistent across all the other
> architectures.  And if you do *that*, I think it would be cool if you
> supplied a generic do-nothing "weak" version in the PCI core.  That
> would allow you to remove it altogether from alpha, ia64, microblaze,
> mips pmc-sierra, parisc, powerpc, sh, sparc, tile, and xtensa.
> 
> CRIS-folk: It would also fix what looks like a bug in cris, which
> implements pcibios_setup() such that pci_setup() doesn't even look for
> all the supposedly generic options.

Ok, thanks for the heads-up!

I'm going to take a look at the PCI code in the CRIS-port.

My current feeling is that the PCI support for CRIS probably
should be dropped, both due to rotted code, but also that the
hardware is hard to come by. I need to do some more digging around...

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
