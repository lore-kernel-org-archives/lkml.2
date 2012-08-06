Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2HFCfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 22:35:38 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:64185 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2HFCfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 22:35:36 -0400
Date: Sun, 5 Aug 2012 22:35:33 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 09/22] ARM: LPAE: use 64-bit pgd physical address in
 switch_mm()
In-Reply-To: <501E8367.8070907@ti.com>
Message-ID: <alpine.LFD.2.02.1208052220060.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-10-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040259200.5231@xanadu.home> <501E8367.8070907@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2012, Cyril Chemparathy wrote:

> On 8/4/2012 3:04 AM, Nicolas Pitre wrote:
> > On Tue, 31 Jul 2012, Cyril Chemparathy wrote:
> > 
> > > This patch modifies the switch_mm() processor functions to use 64-bit
> > > addresses.  We use u64 instead of phys_addr_t, in order to avoid having
> > > config
> > > dependent register usage when calling into switch_mm assembly code.
> > > 
> > > The changes in this patch are primarily adjustments for registers used for
> > > arguments to switch_mm.  The few processor definitions that did use the
> > > second
> > > argument have been modified accordingly.
> > > 
> > > Arguments and calling conventions aside, this patch should be a no-op on
> > > v6
> > > and non-LPAE v7 processors.
> > 
> > NAK.
> > 
> > You just broke all big endian targets, LPAE or not.
> > 
> 
> Indeed.  Thanks.
> 
> Would C-land word swappery on BE do?  Any other ideas on the best approach to
> this?

First, don't use a u64 unconditionally. A phys_addr_t is best for the 
same arguments as before.  Since this is equivalent to a u64 only when 
LPAE is defined, you then only have to care about endian issues in 
proc-v7-3level.S.  And in there you can deal with the issue with 
register aliases just as it is done in lib/div64.S.


Nicolas
