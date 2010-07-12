Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0GLI5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 04:57:35 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58139 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0GLI5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 04:57:34 -0400
X-AuditID: b753bd60-a7602ba000007d15-c0-4c3ad8fb23f6
Message-ID: <4C3AD8F9.5070703@hitachi.com>
Date: Mon, 12 Jul 2010 17:57:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ian Munsie <imunsie@au.ibm.com>,
        Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] perf: Add DWARF register lookup for SH
References: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
In-Reply-To: <e55812819ad18c2ceca5651ac7698a2af46180d7.1278774279.git.matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Fleming wrote:
> Implement get_arch_regstr() for SH so that, given a DWARF register
> number, the corresponding symbolic name of that register can be looked
> up.

KPROBE_EVENT has already been supported on the latest linux-sh,
so this should be work on that.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thanks!

> 
> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  tools/perf/arch/sh/Makefile          |    4 ++
>  tools/perf/arch/sh/util/dwarf-regs.c |   55 ++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/arch/sh/Makefile
>  create mode 100644 tools/perf/arch/sh/util/dwarf-regs.c
> 
> diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
> new file mode 100644
> index 0000000..15130b5
> --- /dev/null
> +++ b/tools/perf/arch/sh/Makefile
> @@ -0,0 +1,4 @@
> +ifndef NO_DWARF
> +PERF_HAVE_DWARF_REGS := 1
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
> +endif
> diff --git a/tools/perf/arch/sh/util/dwarf-regs.c b/tools/perf/arch/sh/util/dwarf-regs.c
> new file mode 100644
> index 0000000..a11edb0
> --- /dev/null
> +++ b/tools/perf/arch/sh/util/dwarf-regs.c
> @@ -0,0 +1,55 @@
> +/*
> + * Mapping of DWARF debug register numbers into register names.
> + *
> + * Copyright (C) 2010 Matt Fleming <matt@console-pimps.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + */
> +
> +#include <libio.h>
> +#include <dwarf-regs.h>
> +
> +/*
> + * Generic dwarf analysis helpers
> + */
> +
> +#define SH_MAX_REGS 18
> +const char *sh_regs_table[SH_MAX_REGS] = {
> +	"r0",
> +	"r1",
> +	"r2",
> +	"r3",
> +	"r4",
> +	"r5",
> +	"r6",
> +	"r7",
> +	"r8",
> +	"r9",
> +	"r10",
> +	"r11",
> +	"r12",
> +	"r13",
> +	"r14",
> +	"r15",
> +	"pc",
> +	"pr",
> +};
> +
> +/* Return architecture dependent register string (for kprobe-tracer) */
> +const char *get_arch_regstr(unsigned int n)
> +{
> +	return (n <= SH_MAX_REGS) ? sh_regs_table[n] : NULL;
> +}

