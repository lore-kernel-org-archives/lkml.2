Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0KHSHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:07:04 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2221 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab0KHSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:07:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Mon, 08 Nov 2010 10:06:18 -0800
Date: Mon, 8 Nov 2010 10:06:16 -0800
From: rmorell@nvidia.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Remove hardcoded include paths for elfutils
Message-ID: <20101108180616.GB24197@morell.nvidia.com>
References: <1288923830-4586-1-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288923830-4586-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with maintainers in To:
(sorry for the noise)

On Thu, Nov 04, 2010 at 07:23:50PM -0700, Robert Morell wrote:
> This change removes the use of hardcoded absolute
> "/usr/include/elfutils" paths from the perf build.  The problem with
> hardcoded paths is that it prevents them from being overridden by
> $prefix or by -I in CFLAGS (e.g., for cross-compiling purposes).
> 
> Instead, just include the "elfutils/" subdirectory as a relative path
> when files are needed from that directory.
> 
> Tested by building perf:
> - Cross-compiled for ARM on x86_64
> - Built natively on x86_64
> - Built on x86_64 with /usr/include/elfutils moved to another location
>   and manually included in CFLAGS
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>
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
> -- 
> 1.7.2.2
> 
