Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2JBBAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 21:00:18 -0400
Received: from edison.jonmasters.org ([173.255.233.168]:34882 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2JBBAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 21:00:14 -0400
X-Greylist: delayed 1027 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2012 21:00:14 EDT
Message-ID: <506A3898.7000804@jonmasters.org>
Date: Mon, 01 Oct 2012 20:43:04 -0400
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <1341608777-12982-11-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-11-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: [PATCH 10/36] AArch64: MMU definitions
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 05:05 PM, Catalin Marinas wrote:

> +/*
> + * PAGE_OFFSET - the virtual address of the start of the kernel image.
> + * VA_BITS - the maximum number of bits for virtual addresses.
> + * TASK_SIZE - the maximum size of a user space task.
> + * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
> + * The module space lives between the addresses given by TASK_SIZE
> + * and PAGE_OFFSET - it must be within 128MB of the kernel text.
> + */
> +#define PAGE_OFFSET		UL(0xffffffc000000000)
> +#define MODULES_END		(PAGE_OFFSET)
> +#define MODULES_VADDR		(MODULES_END - SZ_64M)
> +#define VA_BITS			(39)
> +#define TASK_SIZE_64		(UL(1) << VA_BITS)

Pedantic nit pick. Shouldn't that "it must be within 128MB of the kernel
text" be "within 128MB of the *end* of the kernel text"? The point being
that on AArch64 unconditional branches are encoded as imm26+1 (27 bits)
and so you're going with -64MB to ensure that you're within the range.

Jon.

