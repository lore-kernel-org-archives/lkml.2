Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab2BBViG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:38:06 -0500
Received: from relais.videotron.ca ([24.201.245.36]:12656 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab2BBViE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:38:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 02 Feb 2012 16:38:02 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
In-reply-to: <20120202204411.GB14129@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1202021632400.2759@xanadu.home>
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org>
 <20120202204411.GB14129@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Feb 2012, Russell King - ARM Linux wrote:

> On Thu, Feb 02, 2012 at 11:24:46AM -0800, Stephen Boyd wrote:
> > Should we move get_thread_info into assembler.h? It seems odd
> > to include entry-header.S but I saw that vfp was doing the same.
> 
> Probably yes, and probably also have preempt_disable and preempt_enable
> assembler macros.  That's going to get rather icky if we have to
> explicitly call the scheduler though (to solve (1)).

What about a pair of helpers written in C instead?

v7_flush_dcache_all() could be renamed, and a wrapper function called 
v7_flush_dcache_all() would call the preemption disable helper, call the 
former v7_flush_dcache_all code, then call the preemption enable helper.

Then __v7_setup() could still call the core cache flush code without 
issues.


Nicolas
