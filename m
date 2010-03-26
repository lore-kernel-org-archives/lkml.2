Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0CZIBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 04:01:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54705 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab0CZIBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 04:01:19 -0400
Date: Fri, 26 Mar 2010 09:00:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/16] Tools perf builtin-trace.c: duplicated includes
Message-ID: <20100326080048.GB27394@elte.hu>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
 <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269537767-7553-13-git-send-email-andrea.gelmini@gelma.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrea Gelmini <andrea.gelmini@gelma.net> wrote:

> tools/perf/builtin-trace.c: util/exec_cmd.h and util/trace-event.h are included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
>  tools/perf/builtin-trace.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 407041d..3c699c5 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -59,9 +59,6 @@ static int cleanup_scripting(void)
>  #include "perf.h"
>  #include "util/debug.h"
>  
> -#include "util/trace-event.h"
> -#include "util/exec_cmd.h"
> -
>  static char const		*input_name = "perf.data";
>  
>  static int process_sample_event(event_t *event, struct perf_session *session)

Please send a more complete patch that fixes the root cause of the 
duplication: a few header files are in the middle of the .c file - all 
inclusions should be at the top of the file.

Thanks,

	Ingo
