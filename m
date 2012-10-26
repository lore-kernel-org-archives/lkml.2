Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab2JZPjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:39:14 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:33420 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab2JZPjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:39:12 -0400
Subject: Re: [PATCH 00/11] perf tool: Add PERF_SAMPLE_READ sample read
 support
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20121026102336.GA1067@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <87txti81i2.fsf@sejong.aot.lge.com> <1351242885.16863.0.camel@twins>
	 <20121026102336.GA1067@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Oct 2012 00:39:06 +0900
Message-ID: <1351265946.1619.20.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-26 (금), 12:23 +0200, Jiri Olsa:
> On Fri, Oct 26, 2012 at 11:14:45AM +0200, Peter Zijlstra wrote:
> > I haven't actually looked at the implementation, but I understood it to
> > be a group modifier, not an event modifier.
> 
> we might want to be able to use PERF_SAMPLE_READ for single event
> same as for groups

What is the merits of doing it?

> 
> the difference between single event and group 'S' modifier:
> 
>   $ ./perf record -e 'cycles:S' ls
>   - records 'cycles' samples and read period value via PERF_SAMPLE_READ
> 
>   $ ./perf record -e '{cycles,cache-misses}:S'
>   - samples just on 'cycles' samples and read both period values
>    (cycles and cache-misses) via PERF_SAMPLE_READ group format
> 
>   $ ./perf record -e '{cycles,cache-misses}:S,instructions' ls
>   $ ./perf record -e '{cycles:S,cache-misses},instructions' ls
>   $ ./perf record -e 'cycles:S,instructions' ls
>   - non matching sample_type
> 
> hm, thats the unique sample_type issue again ;) Once we set
> PERF_SAMPLE_READ for event or group, we need to set it for
> all other events in session, otherwise the report fails

Sorry, I don't understand why we need to set it for all events.  Just
setting it for a group is not sufficient?  Please shed some light on
this.

Thanks,
Namhyung

> 
> sooo, it looks like:
>   - global record '-S' option instead, setting PERF_SAMPLE_READ sample type
>     globaly for all events
>   - and ':S' group modifier to enable sampling only on leader
>     with group format reading for the rest of the group
>   - ':S' group modifier alone would imply -S
> 
> How about that?
> 
> thanks,
> jirka



