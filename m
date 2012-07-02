Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2GBPec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:34:32 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:35129 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:34:31 -0400
Date: Mon, 2 Jul 2012 12:34:26 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf target: Ignore return value of strerror_r()
 explicitly
Message-ID: <20120702153426.GC12542@infradead.org>
References: <1341210014-10113-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341210014-10113-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 02, 2012 at 03:20:14PM +0900, Namhyung Kim escreveu:
> Since glibc 2.16 added the warn_unused_result (wur) attribute
> to the function, we should check the return value or ignore it
> explicitly.
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

> +++ b/tools/perf/util/target.c
> @@ -111,7 +111,8 @@ int perf_target__strerror(struct perf_target *target, int errnum,
>  	const char *msg;
>  
>  	if (errnum >= 0) {
> -		strerror_r(errnum, buf, buflen);
> +		/* make glibc (>= 2.16) happy */
> +		(void)strerror_r(errnum, buf, buflen);

Is this really the best way to handle this?

What if some perf tool is buggy and passes an invalid errnum?  Shouldn't
we catch that?

- Arnaldo
