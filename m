Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2HMNYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:24:46 -0400
Received: from mail.x86-64.org ([217.9.48.20]:59814 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2HMNYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:24:44 -0400
Date: Mon, 13 Aug 2012 15:24:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "borislav.petkov" <borislav.petkov@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120813132438.GA18990@aftab.osrc.amd.com>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344864055.6935.117.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 09:20:55AM -0400, Steven Rostedt wrote:
> When I did a compile of perf using a relative path for the output
> directory, the build failed when it tried to compile libtraceevent. This
> is because it continues to use the same relative path when the new
> working directory is in a different path.
> 
>     SUBDIR ../lib/traceevent/
> /bin/sh: line 0: cd: ../../../nobackup/perf/: No such file or directory
> Makefile:74: *** output directory "../../../nobackup/perf/" does not exist.  Stop.
> make: *** [../../../nobackup/perf///libtraceevent.a] Error 2
> 
> 
> Make the path used an absolute path when building perf with O=.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index bde8521..9e3e31e 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -1,6 +1,7 @@
>  ifeq ("$(origin O)", "command line")
> -	OUTPUT := $(O)/
> -	COMMAND_O := O=$(O)
> +	RAW_O := $(shell cd $(O) ; pwd)
> +	OUTPUT := $(RAW_O)/
> +	COMMAND_O := O=$(RAW_O)

So wouldn't it make sense to call this ABSOLUTE_O or so then?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
