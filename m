Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2F1Rbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:31:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab2F1Rbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:31:52 -0400
Subject: Re: [PATCH 12/16] tile/PCI: Factor 'pcibios_setup()' out of tile
From: Myron Stowe <mstowe@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, gxt@mprc.pku.edu.cn, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, chris@zankel.net,
        linux-kernel@vger.kernel.org
In-Reply-To: <4FE9B6C2.7010006@tilera.com>
References: <20120626033045.16434.17412.stgit@amt.stowe>
	 <20120626033218.16434.50584.stgit@amt.stowe>  <4FE9B6C2.7010006@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jun 2012 11:30:47 -0600
Message-ID: <1340904647.2411.8.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 09:18 -0400, Chris Metcalf wrote:
> On 6/25/2012 11:32 PM, Myron Stowe wrote:
> > The PCI core provides a generic (__weak) 'pcibios_setup()' routine
> > that can be used by all architectures as a default.  Drop tile's
> > architecture specific version in favor of that as it does not need to be
> > over-ridden.
> >
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> >
> >  arch/tile/kernel/pci.c |   10 ----------
> >  1 files changed, 0 insertions(+), 10 deletions(-)
> 
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> 
> In our internal tree we have x86-like support for "pci=off" here.  When I
> push that I can just push it as a new function to override the removed one,
> so I'm happy with your change as proposed.

Yes, that should be fine.  Just an FYI - when you introduce the
over-ride, I believe that it should be __init and not __devinit as the
previous tile version of 'pcibios_setup()' was.

>   But perhaps it would make sense
> to move the support for "pci=off" to common code, since multiple
> architectures handle this the same way?

Looking at the tree I only see three of the architectures currently
using/implementing "pci=off" (four with the 'tile' addition).  Perhaps
there is a way to avoid such but it seems like adding this to the core
would require introducing the global variable 'pci_probe' which seems
like unnecessary pollution?

Myron


