Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1BZHCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 02:02:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51589 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab1BZHCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 02:02:32 -0500
Date: Sat, 26 Feb 2011 08:02:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 1/2] perf: Fix undefined PyVarObject_HEAD_INIT in python
 2.5
Message-ID: <20110226070208.GB28222@elte.hu>
References: <1298667956-20675-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298667956-20675-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +++ b/tools/perf/util/python.c
> @@ -8,6 +8,12 @@
>  #include "cpumap.h"
>  #include "thread_map.h"
>  
> +/* Define PyVarObject_HEAD_INIT for python 2.5 */
> +#ifndef PyVarObject_HEAD_INIT
> +#define PyVarObject_HEAD_INIT(type, size) \
> +	PyObject_HEAD_INIT(type) size,
> +#endif

Just a code readability nit - there's really no reason not to write this as:

 #ifndef PyVarObject_HEAD_INIT
 # define PyVarObject_HEAD_INIT(type, size) PyObject_HEAD_INIT(type) size,
 #endif

Thanks,

	Ingo
