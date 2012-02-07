Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab2BGJGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 04:06:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705Ab2BGJGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 04:06:31 -0500
Date: Tue, 7 Feb 2012 10:06:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH] perf-record: no build id option fails
Message-ID: <20120207090622.GC15359@elte.hu>
References: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -504,9 +504,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  			return err;
>  	}
>  
> -	if (!!rec->no_buildid
> +	if (!rec->no_buildid
>  	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
> -		pr_err("Couldn't generating buildids. "
> +		pr_err("Couldn't generate buildids. "
>  		       "Use --no-buildid to profile anyway.\n");

After this fix it might make sense to do a s/no_buildid/build_id 
across the source and negate all the conditions. Generally it's 
cleaner to have no negation in structure field names, it avoids 
such double and triple negation problems.

The feature bit did it correctly: it has HEADER_BUILD_ID which 
signals the presence of build-ids.

( Btw., in error messages it might make sense to do a 
  subsystem-wide s/buildid/build-id rename as well, to make it 
  all easier to read - when I read 'buildid' I often keep 
  wondering who that Buil guy is and what he did. )

Thanks,

	Ingo
