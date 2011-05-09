Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1EIR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 13:29:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:46321 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1EIR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 13:29:47 -0400
Date: Mon, 9 May 2011 22:59:35 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        kexec@lists.infradead.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] Kdump and memory error handling
Message-ID: <20110509172935.GD1963@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20110504193509.GA5342@in.ibm.com>
 <20110504203914.GC1737@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504203914.GC1737@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 10:39:14PM +0200, Andi Kleen wrote:
> > Any thoughts/suggestions?
> 
> My old attempts to solve this are
> 
> Don't dump on MCE:
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/xpanic
> 

The problem we seen in avoiding a panic->crash_kexec->[coredump capture] is
that the user may not have a means to know the reason for crash, unless
the serial console is connected to capture and store the panic string.

Alternatively a 'slim' kdump (as described here:
https://lkml.org/lkml/2011/5/4/396) would not contain meaningless data from
the old memory, but inform the user about the cause of the crash. I'm
intending to post some patches with a quick implementation of it soon.

> Handle dumps of corrupted memory regresions:
> 
> http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/crashdump
> 

> IMHO these patches are still the right solutions for this.
> 

Like Vatsa had raised, the processor's behaviour upon reading (or any I/O
operation) the faulty memory location isn't clearly defined (to the
extent I read through System Programming Guide Part 1, Volume 3A,
Chapter 15). In such a scenario, disabling MCE for the kdump kernel (which can
potentially read the faulty memory) is making things hazy.

Thanks,
K.Prasad

