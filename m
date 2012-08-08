Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab2HHQGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:06:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58140 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab2HHQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:06:36 -0400
Date: Wed, 8 Aug 2012 17:05:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
Message-ID: <20120808160517.GO18957@n2100.arm.linux.org.uk>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040045360.5231@xanadu.home> <50219C45.7030601@ti.com> <alpine.LFD.2.02.1208080106500.5231@xanadu.home> <5022673A.7060407@ti.com> <alpine.LFD.2.02.1208080948210.5231@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1208080948210.5231@xanadu.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 09:55:12AM -0400, Nicolas Pitre wrote:
> On Wed, 8 Aug 2012, Cyril Chemparathy wrote:
> > Neat macro magic.  Are you thinking that we build this in as a self test in
> > the code?
> 
> For such things, this is never a bad idea to have some test alongside 
> with the main code, especially if this is extended to more cases in the 
> future.  It is too easy to break it in subtle ways.
> 
> See arch/arm/kernel/kprobes-test*.c for a precedent.

Done correctly, it shouldn't be a problem, but I wouldn't say that
arch/arm/kernel/kprobes-test*.c is done correctly.  It's seen quite
a number of patching attempts since it was introduced for various
problems, and I've seen quite a number of builds fail for various
reasons in this file (none which I could be bothered to investigate.)

When the test code ends up causing more problems than the code it's
testing, something is definitely wrong.
