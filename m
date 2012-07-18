Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2GRG55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:57:57 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:33303 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2GRG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:57:49 -0400
Message-ID: <50065E6B.3060602@jonmasters.org>
Date: Wed, 18 Jul 2012 02:57:47 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 08/36] AArch64: Kernel booting and initialisation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 05:05 PM, Catalin Marinas wrote:

> +- CPU mode
> +  All forms of interrupts must be masked in PSTATE.DAIF (Debug, SError,
> +  IRQ and FIQ).
> +  The CPU must be in either EL2 (RECOMMENDED) or non-secure EL1.

Even though this stuff is likely to be replaced with the result of some
of the other standardization, I'd like it if you'd strongly consider
removing the "or non-secure EL1". If you give an inch, someone will take
a mile and build a system that enters other than in EL2. Or, something
to the effect of "the highest non-secure exception level implemented"
would be my preference if you don't want to specify.

> diff --git a/arch/aarch64/include/asm/setup.h b/arch/aarch64/include/asm/setup.h

> +#define COMMAND_LINE_SIZE 1024

Suggest at least the same size as x86 (2048) for command line params, or
we'll just be coming back later to change it :)

Jon.
