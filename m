Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab2HDHFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 03:05:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44740 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2HDHE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 03:04:59 -0400
Date: Sat, 4 Aug 2012 03:04:56 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, linux@arm.linux.org.uk,
        will.deacon@arm.com, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 09/22] ARM: LPAE: use 64-bit pgd physical address in
 switch_mm()
In-Reply-To: <1343775898-28345-10-git-send-email-cyril@ti.com>
Message-ID: <alpine.LFD.2.02.1208040259200.5231@xanadu.home>
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-10-git-send-email-cyril@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012, Cyril Chemparathy wrote:

> This patch modifies the switch_mm() processor functions to use 64-bit
> addresses.  We use u64 instead of phys_addr_t, in order to avoid having config
> dependent register usage when calling into switch_mm assembly code.
> 
> The changes in this patch are primarily adjustments for registers used for
> arguments to switch_mm.  The few processor definitions that did use the second
> argument have been modified accordingly.
> 
> Arguments and calling conventions aside, this patch should be a no-op on v6
> and non-LPAE v7 processors. 

NAK.

You just broke all big endian targets, LPAE or not.


Nicolas
