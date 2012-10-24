Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366Ab2JXUEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:04:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933694Ab2JXUEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:04:05 -0400
Date: Wed, 24 Oct 2012 22:03:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Zheng <zheng.z.yan@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [bug] perf_event_intel_uncore.c build warnings on allnoconfig
Message-ID: <20121024200359.GB25643@gmail.com>
References: <20121024072901.GA25890@gmail.com>
 <m2y5ivrdeu.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y5ivrdeu.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> 
> > FYI, on a 'make allnoconfig' x86_64 kernel I get a stream of 
> > warnings:
> >
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ???snbep_uncore_pci_disable_box???:
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c:124:9: warning: ???config??? is used uninitialized in this function [-Wuninitialized]
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ???snbep_uncore_pci_enable_box???:
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c:135:9: warning: ???config??? is used uninitialized in this function [-Wuninitialized]
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c: In function ???snbep_uncore_pci_read_counter???:
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c:164:2: warning: ???count??? is used uninitialized in this function [-Wuninitialized]
> >
> > Please fix this - if pci_read_config_dword() returns an error it 
> > should be handled - that will fix these warnings as well.
> 
> Can it even return an error on x86? I don't know of any 
> existing mechanism for this, short of a machine check.

It will return an error on !CONFIG_PCI at least.

Thanks,

	Ingo
