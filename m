Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2E2Q7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:59:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59638 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab2E2Q7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:59:17 -0400
Message-ID: <1338310743.26856.141.camel@twins>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, hpa <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 May 2012 18:59:03 +0200
In-Reply-To: <20120529152944.GA8263@alberich.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
	 <1338303106.26856.92.camel@twins> <20120529152944.GA8263@alberich.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 17:29 +0200, Andreas Herrmann wrote:

> I've also looked at this. core_siblings mask is broken with this patch.
> And there is this new irritating warning ...

Hehe, you made this irritating hardware ;-) But fair enough.

> I second Boris' suggestion for a fix. But I think the check for
> X86_FEATURE_AMD_DCM should go into topology_sane() which in theory
> could check other things as well.

Unless you plan to go span cache (or even SMT siblings) over physical
IDs I'd strongly argue against putting it in topology_sane().

As it stands I think we should discuss the definition for the generic
topology bits (drivers/base/topology.c), because I think your
Magny-Cours thing does the wrong thing here.

The core span in a phys_id is all nice and such, but what does it mean?
IOW what would you do with it?

I would think the LLC range and the node-span are much more useful
things to have. Once you have nodes the sysfs node topology takes over.

