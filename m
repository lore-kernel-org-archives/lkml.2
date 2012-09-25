Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2IYLW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2IYLWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:22:54 -0400
Date: Tue, 25 Sep 2012 08:22:36 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] perf header: Add check_perf_magic() func
Message-ID: <20120925112236.GD28902@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-8-git-send-email-feng.tang@intel.com>
 <87haqmyhws.fsf@sejong.aot.lge.com>
 <20120925162140.4ecf3d72@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925162140.4ecf3d72@feng-i7>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 04:21:40PM +0800, Feng Tang escreveu:
> On Tue, 25 Sep 2012 11:07:15 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > On Mon, 24 Sep 2012 23:24:09 +0800, Feng Tang wrote:
> > [snip]
> > > +/* Return 0 if matched */
> > > +int check_perf_magic(u64 magic)
> > > +{
> > > +	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
> > > +		|| magic == __perf_magic2
> > > +		|| magic == __perf_magic2_sw)
> > > +		return 0;
> > > +
> > > +	return -1;
> > > +}
> > 
> > Just an idea.  How about returning version number instead of 0 so that
> > it can be used elsewhere those check is needed and possibly wants to
> > know the version number also?
 
> Sounds ok to me, I can add that if nobody has objection.

Leave it for when we need it?

What we need now is to see if a file is a perf.data file, so I think the
function is good as is.

Minor nitpicks: use bool, rename it to is_perf_magic(), no need for that
comment then, it becomes obvious from the function name :-)

- Arnaldo
