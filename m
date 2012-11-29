Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2K2MG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:06:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2K2MGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:06:55 -0500
Date: Thu, 29 Nov 2012 13:06:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 09/14] perf diff: Update perf diff documentation for
 multiple data comparison
Message-ID: <20121129120612.GC1096@krava.brq.redhat.com>
References: <1354110769-2998-1-git-send-email-jolsa@redhat.com>
 <1354110769-2998-10-git-send-email-jolsa@redhat.com>
 <87ip8oocct.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip8oocct.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:52:18PM +0900, Namhyung Kim wrote:
> On Wed, 28 Nov 2012 14:52:44 +0100, Jiri Olsa wrote:
> > +COMPARISON
> > +----------
> > +The comparison is governed by the baseline file. The baseline perf.data
> > +file is iterated for samples. All other perf.data files specified on
> > +the command line are searched for the baseline sample pair. If the pair
> > +is found, specified computation is made and result is displayed.
> > +
> > +All samples from non-baseline perf.data files, that do not match any
> > +baseline entry, are displayed with empty space within baseline column
> > +and possible computation results (delta) in their related column.
> > +
> > +Example files samples:
> > +- file A with samples f1, f2, f3, f4,    f6
> > +- file B with samples     f2,     f4, f5
> > +- file C with samples f1, f2,         f5
> > +
> > +Example output:
> > +  x - computation takes place for pair
> > +  b - baseline sample percentage
> > +
> > +- perf diff A B C
> > +
> > +  baseline/A compute/B compute/C  samples
> > +  ---------------------------------------
> > +  b                    x          f1
> > +  b          x         x          f2
> > +  b                               f3
> > +  b          x                    f4
> > +  b                               f6
> > +             x         x          f5
> > +
> > +- perf diff B A C
> > +
> > +  baseline/B compute/A compute/C  samples
> > +  ---------------------------------------
> > +  b          x         x          f2
> > +  b          x                    f4
> > +  b                    x          f5
> > +             x         x          f1
> > +             x                    f3
> > +             x                    f6
> > +
> > +- perf diff C B A
> > +
> > +  baseline/C compute/B compute/A  samples
> > +  ---------------------------------------
> > +  b                    x          f1
> > +  b          x         x          f2
> > +  b          x                    f5
> > +                       x          f3
> > +             x         x          f4
> > +                       x          f6
> > +
> 
> It seems not work this way.  When I test multiple diff, I didn't get
> consecutive 'b's on the baseline column like your example in the cover
> letter of this series.

the baseline consecutiveness is just for sake of the doc readibility
it just presents logical output to get user some idea 

final output could be sorted by column data using -o <column number>

the initial diff output (no options) is sort of sorted by baseline ;)
you're right, that should be fixed.. by default sorted by baseline

jirka
