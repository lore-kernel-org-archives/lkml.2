Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2K2PJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:09:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59195 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2K2PJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:09:17 -0500
Subject: Re: [PATCH 03/18] perf tools: Keep group information
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <20121129150220.GL1096@krava.brq.redhat.com>
References: <1354171126-14387-1-git-send-email-namhyung@kernel.org>
	 <1354171126-14387-5-git-send-email-namhyung@kernel.org>
	 <20121129143303.GJ1096@krava.brq.redhat.com>
	 <1354201134.1630.41.camel@leonhard>
	 <20121129150220.GL1096@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Nov 2012 00:09:11 +0900
Message-ID: <1354201751.1630.45.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-11-29 (목), 16:02 +0100, Jiri Olsa:
> On Thu, Nov 29, 2012 at 11:58:54PM +0900, Namhyung Kim wrote:
> > 2012-11-29 (목), 15:33 +0100, Jiri Olsa:
> > > On Thu, Nov 29, 2012 at 03:38:31PM +0900, Namhyung Kim wrote:
> > > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > SNIP
> > > 
> > > > --- a/tools/perf/util/evlist.h
> > > > +++ b/tools/perf/util/evlist.h
> > > > @@ -21,6 +21,7 @@ struct perf_evlist {
> > > >  	struct list_head entries;
> > > >  	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
> > > >  	int		 nr_entries;
> > > > +	int		 nr_groups;
> > > >  	int		 nr_fds;
> > > >  	int		 nr_mmaps;
> > > >  	int		 mmap_len;
> > > > diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
> > > > index 46c8004ca56b..887834ed0af1 100644
> > > > --- a/tools/perf/util/evsel.h
> > > > +++ b/tools/perf/util/evsel.h
> > > > @@ -73,6 +73,7 @@ struct perf_evsel {
> > > >  	bool 			needs_swap;
> > > >  	/* parse modifier helper */
> > > >  	int			exclude_GH;
> > > > +	int			nr_members;
> > > >  	struct perf_evsel	*leader;
> > > >  	char			*group_name;
> > > >  };
> > > 
> > > we could test both new fields in existing group tests
> > > 
> > > > @@ -230,4 +231,9 @@ static inline bool perf_evsel__is_group_leader(const struct perf_evsel *evsel)
> > > >  {
> > > >  	return evsel->leader == evsel;
> > > 
> > 
> > You mean adding 'evsel->nr_members > 1' to this function?  For some
> > reason, I'd like to treat non-group events as group leaders so I dropped
> > that check from the function.
> 
> nope, the change is ok, I meant updating automated tests in tests/parse-events.c

Ah, okay.  Always forgot to update the test. :(  Will add.

Thanks,
Namhyung



