Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2ANXgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:36:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2ANXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:36:48 -0500
Date: Sat, 14 Jan 2012 23:36:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] ARM: Fix regression caused by ARCH_NR_GPIOS removal
Message-ID: <20120114233626.GA11769@n2100.arm.linux.org.uk>
References: <201201150033.25885.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201150033.25885.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 12:33:25AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit 3dea19e826da3dd43b3dc308aca299c0b7263c6b (ARM: 7244/1:
> mach-shmobile: Use CONFIG_ARCH_NR_GPIO) removed ARCH_NR_GPIOS
> and introduced ARCH_NR_GPIO instead without changing the users
> of that symbol.  As a result, the kernels including that commit
> don't boot on my test-bed Mackerel board.
> 
> Fix the problem by defining ARCH_NR_GPIOS again.

I'm aware of it, and have:

commit ca95023e7521729d3ace6fb3b9c53281c510a18c
Author: Stephen Warren <swarren@nvidia.com>
Date:   Thu Jan 5 21:36:27 2012 +0100

    ARM: 7271/1: Fix typo in conversion of ARCH_NR_GPIOS to Kconfig
    
    Commit 44986ab "ARM: 7240/1: Make ARCH_NR_GPIO a Kconfig variable"
    spelled ARCH_NR_GPIOS as ARCH_NR_GPIO, hence making the change
    ineffective. This change fixes that.
    
    Signed-off-by: Stephen Warren <swarren@nvidia.com>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

already queued up.
