Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0EGQeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:34:50 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:49202 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756457Ab0EGQes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:34:48 -0400
X-SpamScore: -11
X-BigFish: VPS-11(z1857rz1432P98dN936eM62a3Lab9bh7cf0izz1202hzz6ff19hz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L2261L-02-3VS-02
X-M-MSG: 
Date: Fri, 7 May 2010 18:34:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf probe: Support DW_OP_call_frame_cfa in
 debuginfo
Message-ID: <20100507163321.GB15333@erda.amd.com>
References: <20100412171728.3790.98217.stgit@localhost6.localdomain6>
 <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <tip-a34a985499895a46a4dacff727d0fbc63cdc75e8@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.10 07:29:18, tip-bot for Masami Hiramatsu wrote:
> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> index 2a27132..310ce89 100644
> --- a/tools/perf/util/probe-finder.h
> +++ b/tools/perf/util/probe-finder.h
> @@ -42,6 +42,7 @@ struct probe_finder {
>  	struct list_head	lcache;		/* Line cache for lazy match */
>  
>  	/* For variable searching */
> +	Dwarf_CFI		*cfi;		/* Call Frame Information */

I get the following complile error:

gcc -o builtin-probe.o -c -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement  -fstack-protector-all -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Iutil/include -I/usr/include/elfutils -DDWARF_SUPPORT -DNO_NEWT_SUPPORT -DNO_LIBPERL -DSHA1_HEADER='<openssl/sha.h>'  builtin-probe.c
In file included from builtin-probe.c:43:
util/probe-finder.h:45: error: expected specifier-qualifier-list before ‘Dwarf_CFI’
make: *** [builtin-probe.o] Error 1
build script error: 2

git grep only finds the following:

 $ git grep Dwarf_CFI 
 tools/perf/util/probe-finder.h: Dwarf_CFI               *cfi;           /* Call Frame Information */

Am I missing something?

-Robert

>  	Dwarf_Op		*fb_ops;	/* Frame base attribute */
>  	struct perf_probe_arg	*pvar;		/* Current target variable */
>  	struct kprobe_trace_arg	*tvar;		/* Current result variable */

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

