Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2HFSCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:02:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33673 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2HFSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:02:23 -0400
Date: Mon, 6 Aug 2012 14:02:19 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        will.deacon@arm.com
Subject: Re: [PATCH 01/22] ARM: add mechanism for late code patching
In-Reply-To: <20120806132642.GC18957@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1208061356480.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-2-git-send-email-cyril@ti.com> <20120806111224.GA18957@n2100.arm.linux.org.uk> <501FC44E.1040806@ti.com> <20120806132642.GC18957@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2012, Russell King - ARM Linux wrote:

> On Mon, Aug 06, 2012 at 09:19:10AM -0400, Cyril Chemparathy wrote:
> > With a flush_cache_all(), we could avoid having to operate a cacheline  
> > at a time, but that clobbers way more than necessary.
> 
> You can't do that, because flush_cache_all() on some CPUs requires the
> proper MMU mappings to be in place, and you can't get those mappings
> in place because you don't have the V:P offsets fixed up in the kernel.
> Welcome to the chicken and egg problem.

This problem is fixed in this case by having the p2v and v2p code sites 
using an out-of-line non optimized computation until those sites are 
runtime patched with the inlined optimized computation we have today.


Nicolas
