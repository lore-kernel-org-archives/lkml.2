Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab2G3V4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 17:56:54 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52081 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab2G3V4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 17:56:52 -0400
Date: Mon, 30 Jul 2012 22:56:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
Message-ID: <20120730215617.GA10335@n2100.arm.linux.org.uk>
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 02:30:03PM -0700, Stephen Boyd wrote:
> Add the ARM machine identifier to sortextable and select the
> config option so that we can sort the exception table at compile
> time. sortextable relies on a section named __ex_table existing
> in the vmlinux, but ARM's linker script places the exception
> table in the data section. Give the exception table its own
> section so that sortextable can find it.
> 
> This allows us to skip the runtime sorting step during boot.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: David Daney <david.daney@cavium.com>
> ---
> 
> I can't find any information on why the exception table lives in the data
> section. If there's a good reason for that, I'll look into changing
> sortextable to look for the __start___ex_table symbol.

Be careful about the placement of this, especially with XIP.

