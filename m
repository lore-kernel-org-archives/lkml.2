Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423092Ab2CPP6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:58:19 -0400
Received: from mail1.windriver.com ([147.11.146.13]:61056 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965484Ab2CPP6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:58:17 -0400
Message-ID: <4F636307.1050404@windriver.com>
Date: Fri, 16 Mar 2012 10:57:59 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 1/4] kgdb: x86: Return all segment registers also in 64-bit
 mode
References: <cover.1331900215.git.jan.kiszka@siemens.com> <04b93bdc9d3d8ea89dc42adf055ce1c0787bb91f.1331900215.git.jan.kiszka@siemens.com>
In-Reply-To: <04b93bdc9d3d8ea89dc42adf055ce1c0787bb91f.1331900215.git.jan.kiszka@siemens.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 07:17 AM, Jan Kiszka wrote:
> Even if the content is always 0, gdb expects us to return also ds,
> es, fs, and gs while in x86-64 mode. Do this to avoid ugly errors on
> "info registers".
>
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  arch/x86/include/asm/kgdb.h |    6 +++++-
>  arch/x86/kernel/kgdb.c      |    6 ++++--
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kgdb.h b/arch/x86/include/asm/kgdb.h
> index 77e95f5..e857f1a 100644
> --- a/arch/x86/include/asm/kgdb.h
> +++ b/arch/x86/include/asm/kgdb.h
> @@ -64,9 +64,13 @@ enum regnames {
>  	GDB_PS,			/* 17 */
>  	GDB_CS,			/* 18 */
>  	GDB_SS,			/* 19 */
> +	GDB_DS,			/* 20 */
> +	GDB_ES,			/* 21 */
> +	GDB_FS,			/* 22 */
> +	GDB_GS,			/* 23 */
>  };
>  #define GDB_ORIG_AX		57
> -#define DBG_MAX_REG_NUM		20
> +#define DBG_MAX_REG_NUM		24
>  /* 17 64 bit regs and 3 32 bit regs */
>  #define NUMREGBYTES		((17 * 8) + (3 * 4))

You bumped the register numbers correctly, but you also need to add the correct padding to the NUMREGBYTES or you might not get a large enough memory block for the register struct.

You added 2 32 bit regs, so it should change to:

/* 17 64 bit regs and 5 32 bit regs */
#define NUMREGBYTES        ((17 * 8) + (5 * 4))


The rest should be fine.   I can test this and add it to the merge queue with the NUMREGBYTES change, unless you disagree.

Cheers,
Jason.
