Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2GGXZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:25:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53871 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2GGXZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:25:43 -0400
Date: Sun, 8 Jul 2012 00:29:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120708002920.4f55c737@pyramind.ukuu.org.uk>
In-Reply-To: <20120707231456.GA21201@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<20120706235804.1bd26a1a@pyramind.ukuu.org.uk>
	<20120707231456.GA21201@arm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 1. The AArch64 architecture is significantly different from AArch32 (the
> official name of the 32-bit ARM architecture), it is not an extension.
> It has a new exception model, new instruction set (even the register
> names are different), new C ABI, PCS. It has a hardware compat mode but
> that's about it, there is no interworking between the two (not allowed
> by hardware, nor that the ABIs would make this possible). 
> 
> 2. Easier code maintenance. While I started the kernel port from the
> arch/arm/ code base (it was at a time when Linux didn't even have
> generic unistd.h and the AArch64 specs kept changing) the code diverged
> significantly both because of architecture differences and software
> requirements like new ABI, generic headers (unistd.h, stat.h etc). The
> port undergone significant rewrite following the rules for new
> architecture ports and some of the few similarities will be moved to a
> more generic place (like the mmu_gather patches from peterz). AArch64
> SoCs are going into a more standardised direction and the SoC code will
> be kept to a minimum and moved under drivers/. So merging AArch32 and
> AArch64 together would be rather detrimental to code maintenance for
> both architectures (#ifdef's or duplicate 32/64 files).
> 
> 3. Flexibility. It's early days for AArch64, we don't have a hardware
> platform supported yet and there are ongoing debates around ACPI,
> firmware standardisation for CPU booting, hotplug, power management. We
> need the flexibility to improve the code base without worrying about
> backwards compatibility (apart from the compat layer which isn't at all
> affected by the hardware developments).

These are the same reasons the x86_64 people gave and regretted later.

Alan
