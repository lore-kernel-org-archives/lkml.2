Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258Ab2IGJ2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:28:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758199Ab2IGJ2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:28:47 -0400
Date: Fri, 7 Sep 2012 11:28:31 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 09/12] perf diff: Add weighted diff computation way to
 compare hist entries
Message-ID: <20120907092831.GB3411@krava.brq.redhat.com>
References: <1346946426-13496-1-git-send-email-jolsa@redhat.com>
 <1346946426-13496-10-git-send-email-jolsa@redhat.com>
 <87wr06bchw.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wr06bchw.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 02:58:19PM +0900, Namhyung Kim wrote:
> On Thu,  6 Sep 2012 17:47:03 +0200, Jiri Olsa wrote:
> > Adding 'wdiff' as new computation way to compare hist entries.

SNIP

> > +static int setup_compute_opt_wdiff(char *opt)
> > +{
> > +	char *w1_str = opt;
> > +	char *w2_str;
> > +
> > +	int ret = -EINVAL;
> > +
> > +	do {
> > +		if (!opt)
> > +			break;
> > +
> > +		w2_str = strchr(opt, ',');
> > +		if (!w2_str)
> > +			break;
> > +
> > +		*w2_str++ = 0x0;
> > +		if (!*w2_str)
> > +			break;
> > +
> > +		compute_wdiff_w1 = strtol(w1_str, NULL, 10);
> > +		compute_wdiff_w2 = strtol(w2_str, NULL, 10);
> > +
> > +		if (!compute_wdiff_w1 || !compute_wdiff_w2)
> > +			break;
> > +
> > +		pr_debug("compute wdiff w1(%" PRId64 ") w2(%" PRId64 ")\n",
> > +			  compute_wdiff_w1, compute_wdiff_w2);
> > +		ret = 0;
> > +
> > +	} while (0);
> 
> I don't see why this do { } while(0) loop is necessary.
> How about this?
> 
> 	w1 = strtol(opt, &tmp, 10);
> 	if (*tmp != ',')
> 		goto error;
> 
> 	opt = tmp + 1;
> 	w2 = strtol(opt, &tmp, 10);
> 	if (*tmp != '\0')
> 		goto error;
> 
> 	if (!w1 || !w2)
> 		goto error;

I do this not to use labels & goto ;)

jirka
