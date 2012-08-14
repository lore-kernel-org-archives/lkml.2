Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab2HNX3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:29:10 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62429 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab2HNX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:29:07 -0400
Date: Tue, 14 Aug 2012 16:29:07 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/31] arm64: Exception handling
Message-ID: <20120814232907.GB19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-4-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This one is a bit denser, so just a quick first pass with a couple of minor
comments. I'll revisit the rest.

On Tue, Aug 14, 2012 at 06:52:04PM +0100, Catalin Marinas wrote:

> +el1_sp_pc:
> +	/*
> +	 *Stack or PC alignment exception handling
> +	 */
> +	mrs	x0, far_el1
> +	mov	x1, x25
> +	mov	x2, sp
> +	b	do_sp_pc_abort
> +el1_undef:
> +	/*
> +	 *Undefined instruction
> +	 */

Nit: Missing spaces in the comment here and the one above.

> +el0_undef:
> +	/*
> +	 *Undefined instruction
> +	 */
> +	mov	x0, sp
> +	b	do_undefinstr

Here too.

> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> new file mode 100644
> index 0000000..8712a8e
> --- /dev/null
> +++ b/arch/arm64/kernel/traps.c
[...]
> +DEFINE_SPINLOCK(die_lock);

Should probably be static.

