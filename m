Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2JZRAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:00:47 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:47877 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab2JZRAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:00:45 -0400
Date: Fri, 26 Oct 2012 10:00:34 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read support
Message-ID: <20121026170034.GB20695@ghostprotocols.net>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <87txti81i2.fsf@sejong.aot.lge.com>
 <1351242885.16863.0.camel@twins>
 <20121026102336.GA1067@krava.brq.redhat.com>
 <1351265946.1619.20.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351265946.1619.20.camel@leonhard>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Oct 27, 2012 at 12:39:06AM +0900, Namhyung Kim escreveu:
> 2012-10-26 (금), 12:23 +0200, Jiri Olsa:
> >   $ ./perf record -e '{cycles,cache-misses}:S,instructions' ls
> >   $ ./perf record -e '{cycles:S,cache-misses},instructions' ls
> >   $ ./perf record -e 'cycles:S,instructions' ls
> >   - non matching sample_type
> > 
> > hm, thats the unique sample_type issue again ;) Once we set
> > PERF_SAMPLE_READ for event or group, we need to set it for
> > all other events in session, otherwise the report fails
> 
> Sorry, I don't understand why we need to set it for all events.  Just
> setting it for a group is not sufficient?  Please shed some light on
> this.

Artificial limitation on having multiple sample_type's on a single
perf.data?

My plan is to experiment with multiple evlists in 'trace' to get, say,
callchains on some events but not in the others.

- Arnaldo
