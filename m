Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2HPQH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:07:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab2HPQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:07:57 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=nJMv3_NQHZAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=OgzBD95Qp9sA:10 a=AB1JvJ2Xp7bCHqSPeiMA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345133274.3708.0.camel@gandalf.local.home>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Thu, 16 Aug 2012 12:07:54 -0400
In-Reply-To: <20120815163923.GD15989@aftab.osrc.amd.com>
References: <20120813132438.GA18990@aftab.osrc.amd.com>
	 <1344867782.6935.119.camel@gandalf.stny.rr.com>
	 <20120813142909.GC18990@aftab.osrc.amd.com>
	 <20120813180249.GB6840@infradead.org>
	 <20120815102722.GB4640@aftab.osrc.amd.com>
	 <20120815130634.GE2370@infradead.org>
	 <20120815131806.GC4640@aftab.osrc.amd.com>
	 <1345041485.31459.89.camel@twins>
	 <20120815144255.GB15989@aftab.osrc.amd.com>
	 <20120815145935.GI2370@infradead.org>
	 <20120815163923.GD15989@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 18:39 +0200, Borislav Petkov wrote:

> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index bde8521d56bb..96ce80a3743b 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -1,6 +1,8 @@
>  ifeq ("$(origin O)", "command line")
> -	OUTPUT := $(O)/
> -	COMMAND_O := O=$(O)
> +	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
> +	ABSOLUTE_O := $(shell cd $(O) ; pwd)
> +	OUTPUT := $(ABSOLUTE_O)/
> +	COMMAND_O := O=$(ABSOLUTE_O)
>  endif
>  

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Arnaldo, can you pick this patch? Keep both the Signed-off-bys that
Boris placed.

Thanks!

-- Steve


