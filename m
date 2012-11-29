Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2K2PCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:02:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab2K2PCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:02:39 -0500
Date: Thu, 29 Nov 2012 16:02:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 03/18] perf tools: Keep group information
Message-ID: <20121129150220.GL1096@krava.brq.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
 <1354171126-14387-5-git-send-email-namhyung@kernel.org>
 <20121129143303.GJ1096@krava.brq.redhat.com>
 <1354201134.1630.41.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354201134.1630.41.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:58:54PM +0900, Namhyung Kim wrote:
> 2012-11-29 (목), 15:33 +0100, Jiri Olsa:
> > On Thu, Nov 29, 2012 at 03:38:31PM +0900, Namhyung Kim wrote:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > SNIP
> > 
> > > --- a/tools/perf/util/evlist.h
> > > +++ b/tools/perf/util/evlist.h
> > > @@ -21,6 +21,7 @@ struct perf_evlist {
> > >  	struct list_head entries;
> > >  	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
> > >  	int		 nr_entries;
> > > +	int		 nr_groups;
> > >  	int		 nr_fds;
> > >  	int		 nr_mmaps;
> > >  	int		 mmap_len;
> > > diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> > > index 46c8004ca56b..887834ed0af1 100644
> > > --- a/tools/perf/util/evsel.h
> > > +++ b/tools/perf/util/evsel.h
> > > @@ -73,6 +73,7 @@ struct perf_evsel {
> > >  	bool 			needs_swap;
> > >  	/* parse modifier helper */
> > >  	int			exclude_GH;
> > > +	int			nr_members;
> > >  	struct perf_evsel	*leader;
> > >  	char			*group_name;
> > >  };
> > 
> > we could test both new fields in existing group tests
> > 
> > > @@ -230,4 +231,9 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
> > >  {
> > >  	return evsel->leader == evsel;
> > 
> 
> You mean adding 'evsel->nr_members > 1' to this function?  For some
> reason, I'd like to treat non-group events as group leaders so I dropped
> that check from the function.

nope, the change is ok, I meant updating automated tests in tests/parse-events.c

thanks,
jirka
