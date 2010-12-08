Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0LHWvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:51:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539Ab0LHWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:51:13 -0500
Date: Wed, 8 Dec 2010 14:50:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH v5 resend] OLPC: Add XO-1 suspend/resume support
Message-Id: <20101208145040.e23f832d.akpm@linux-foundation.org>
In-Reply-To: <20101203141828.33E8F9D401B@zog.reactivated.net>
References: <20101203141828.33E8F9D401B@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  3 Dec 2010 14:18:27 +0000 (GMT)
Daniel Drake <dsd@laptop.org> wrote:

> Add code needed for basic suspend/resume of the XO-1 laptop.
> 
> As distro kernels would prefer to build XO-1 support modular, we have
> had to export suspend_set_ops() and create an exported function for
> reading the address of the initial page table.
> 
> Due to complications compiling asm into a module, the olpc-xo1.c file had to
> be renamed to have a name different from the target module name.
> 
> Based on earlier work by Jordan Crouse, Andres Salomon, and others.

x86_64 allmodconfig gives me

{standard input}: Assembler messages:
{standard input}:300: Error: suffix or operands invalid for `mov'

due to

        movl %rax,%eax  # tmp70

in olpc_xo1_do_sleep().


Also, this checkpatch warning

WARNING: struct platform_suspend_ops should normally be const
#502: FILE: arch/x86/platform/olpc/xo1.c:106:
+static struct platform_suspend_ops xo1_suspend_ops = {

seems valid.


Also, something in today's linux-next has mucked up the x86 Kconfig:

drivers/platform/x86/Kconfig:422:error: recursive dependency detected!
drivers/platform/x86/Kconfig:422:       symbol EEEPC_WMI depends on ACPI_WMI
drivers/platform/x86/Kconfig:438:       symbol ACPI_WMI is selected by ACER_WMI
drivers/platform/x86/Kconfig:18:        symbol ACER_WMI depends on LEDS_CLASS

