Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab1GOJJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 05:09:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:58039 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964982Ab1GOJJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 05:09:49 -0400
Subject: Re: Dropped IRQ disables Radeon 3D
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Witten <mfwitten@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnuschky <arnuschky@xylon.de>
In-Reply-To: <0fe54f4a77b64475b9e6041d9ef5772b-mfwitten@gmail.com>
References: <d74f405530c34a2f9fdae3d7cf37e0fcmfwitten@gmail.com>
	 <0fe54f4a77b64475b9e6041d9ef5772b-mfwitten@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 19:09:44 +1000
Message-ID: <1310720984.4968.313.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 08:20 +0000, Michael Witten wrote:
> 
> Arnuschky wrote to me about this related Debian bug report:
> 
>   Fri, 2010-06-18 10:21:05 +0000
>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586312
> 
> I popped over to #radeon on freenode where user agd5f told me to
> try the following on the kernel command line:
> 
>   pci=nomsi
> 
> After reading about MSIs and the requisite CONFIG_* settings, I
> realized that I didn't even have MSI support in the kernel anyway.
> Then agd5f suggested the following patches by Benjamin Herrenschmidt
> might be of help:

Another problem I noticed is some cards, when not using MSIs, still seem
to shoot an MSI with whatever value was last programmed into the MSI
configuration space. Can you check with lspci -vv if there's a non-0
value in there ? It -could- be that your get bogus MSIs.

Cheers,
Ben.

> 
> http://lists.freedesktop.org/archives/dri-devel/2011-July/012980.html
> 
> http://lists.freedesktop.org/archives/dri-devel/2011-July/012981.html
> 
> the latter of which fixes a syncronization bug on systems that use
> non-MSI IRQs (presumably pin-based IRQs) for the radeon device/driver.
> 
> For my system, I decided to enable MSI/MSI-X support by building
> Linux with the following configuration variables set:
> 
>   CONFIG_PCI=y
>   CONFIG_X86_LOCAL_APIC=y
>   CONFIG_X86_IO_APIC=y
>   CONFIG_PCI_MSI=y
> 
> and making sure I get the following:
> 
>   $ dmesg | grep MSI | grep radeon 
>   radeon 0000:01:00.0: irq 42 for MSI/MSI-X
>   radeon 0000:01:00.0: radeon: using MSI.
> 
> I'm not sure if this will avoid the problem, but it sure seems like
> a good bet.
> 
> 

