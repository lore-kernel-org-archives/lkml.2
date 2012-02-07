Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2BGOua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 09:50:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42762 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab2BGOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 09:50:29 -0500
Date: Tue, 7 Feb 2012 12:50:21 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH] perf-record: no build id option fails
Message-ID: <20120207145021.GD2172@infradead.org>
References: <1328567272-13190-1-git-send-email-dsahern@gmail.com>
 <20120207090622.GC15359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207090622.GC15359@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 07, 2012 at 10:06:23AM +0100, Ingo Molnar escreveu:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -504,9 +504,9 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
> >  			return err;
> >  	}
> >  
> > -	if (!!rec->no_buildid
> > +	if (!rec->no_buildid
> >  	    && !perf_header__has_feat(&session->header, HEADER_BUILD_ID)) {
> > -		pr_err("Couldn't generating buildids. "
> > +		pr_err("Couldn't generate buildids. "
> >  		       "Use --no-buildid to profile anyway.\n");
> 
> After this fix it might make sense to do a s/no_buildid/build_id 
> across the source and negate all the conditions. Generally it's 
> cleaner to have no negation in structure field names, it avoids 
> such double and triple negation problems.
> 
> The feature bit did it correctly: it has HEADER_BUILD_ID which 
> signals the presence of build-ids.
> 
> ( Btw., in error messages it might make sense to do a 
>   subsystem-wide s/buildid/build-id rename as well, to make it 
>   all easier to read - when I read 'buildid' I often keep 
>   wondering who that Buil guy is and what he did. )

Yeah, making it consistently build_id (and build-id in command line
options) is better than disturbing Buil, as he did nothing to deserve
that level of disturbance from these pesky linux guys ;-)

- Arnaldo
