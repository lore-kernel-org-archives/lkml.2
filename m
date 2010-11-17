Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018Ab0KQCL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 21:11:28 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50480 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395Ab0KQCL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 21:11:27 -0500
X-AuditID: b753bd60-a69a5ba000003e7d-25-4ce339ccc323
Message-ID: <4CE339C3.6070009@hitachi.com>
Date: Wed, 17 Nov 2010 11:11:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Robert Morell <rmorell@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] perf: Remove hardcoded include paths for elfutils
References: <1289945793-31441-1-git-send-email-rmorell@nvidia.com>
In-Reply-To: <1289945793-31441-1-git-send-email-rmorell@nvidia.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/11/17 7:16), Robert Morell wrote:
> This change removes the use of hardcoded absolute
> "/usr/include/elfutils" paths from the perf build.  The problem with
> hardcoded paths is that it prevents them from being overridden by
> $prefix or by -I in CFLAGS (e.g., for cross-compiling purposes).
> 
> Instead, just include the "elfutils/" subdirectory as a relative path
> when files are needed from that directory.

Looks good to me, Thanks!

> 
> Tested by building perf:
> - Cross-compiled for ARM on x86_64
> - Built natively on x86_64
> - Built on x86_64 with /usr/include/elfutils moved to another location
>   and manually included in CFLAGS
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> ---
>  tools/perf/Makefile            |    4 ++--
>  tools/perf/feature-tests.mak   |    4 ++--
>  tools/perf/util/probe-finder.h |    6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index d1db0f6..74b684d 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -507,7 +507,7 @@ PERFLIBS = $(LIB_FILE)
>  -include config.mak
>  
>  ifndef NO_DWARF
> -FLAGS_DWARF=$(ALL_CFLAGS) -I/usr/include/elfutils -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
> +FLAGS_DWARF=$(ALL_CFLAGS) -ldw -lelf $(ALL_LDFLAGS) $(EXTLIBS)
>  ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF)),y)
>  	msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
>  	NO_DWARF := 1
> @@ -554,7 +554,7 @@ ifndef NO_DWARF
>  ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
>  	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
>  else
> -	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
> +	BASIC_CFLAGS += -DDWARF_SUPPORT
>  	EXTLIBS += -lelf -ldw
>  	LIB_OBJS += $(OUTPUT)util/probe-finder.o
>  endif # PERF_HAVE_DWARF_REGS
> diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
> index b253db6..b041ca6 100644
> --- a/tools/perf/feature-tests.mak
> +++ b/tools/perf/feature-tests.mak
> @@ -9,8 +9,8 @@ endef
>  ifndef NO_DWARF
>  define SOURCE_DWARF
>  #include <dwarf.h>
> -#include <libdw.h>
> -#include <version.h>
> +#include <elfutils/libdw.h>
> +#include <elfutils/version.h>
>  #ifndef _ELFUTILS_PREREQ
>  #error
>  #endif
> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> index bba69d4..beaefc3 100644
> --- a/tools/perf/util/probe-finder.h
> +++ b/tools/perf/util/probe-finder.h
> @@ -34,9 +34,9 @@ extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
>  				  bool externs);
>  
>  #include <dwarf.h>
> -#include <libdw.h>
> -#include <libdwfl.h>
> -#include <version.h>
> +#include <elfutils/libdw.h>
> +#include <elfutils/libdwfl.h>
> +#include <elfutils/version.h>
>  
>  struct probe_finder {
>  	struct perf_probe_event	*pev;		/* Target probe event */


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
