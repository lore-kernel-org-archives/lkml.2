Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab2GCBFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 21:05:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab2GCBE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 21:04:59 -0400
Date: Mon, 2 Jul 2012 22:04:21 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, eranian@google.com
Subject: Re: [PATCHv3 0/3] perf tool: Add new event group management
Message-ID: <20120703010420.GA7533@infradead.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <87fw9blyhj.fsf@sejong.aot.lge.com>
 <20120702101518.GC967@krava.redhat.com>
 <1341234662.1476.13.camel@leonhard>
 <20120702133341.GD967@krava.redhat.com>
 <1341238834.1476.50.camel@leonhard>
 <877gulmzw4.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877gulmzw4.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 03, 2012 at 09:50:19AM +0900, Namhyung Kim escreveu:
> On Mon, 02 Jul 2012 23:20:34 +0900, Namhyung Kim wrote:
> > We could pass such information to perf report explicitly, But I guess it
> > 'd better if perf report did it for me automagically by detecting group
> > relations.
> 
> Oh I think we can do it by parsing the command line (again) at the perf
> report time. In that way, no need to change the file format. I'm gonna
> give it a shot later.

Its there already...

[acme@felicio ~]$ perf record -e cycles,cache-misses sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.016 MB perf.data (~713 samples) ]
[acme@felicio ~]$ perf report --stdio | head -20
# ========
# captured on: Mon Jul  2 22:02:00 2012
# hostname : felicio.ghostprotocols.net
# os release : 3.4.0-rc5+
# perf version : 3.5.rc1.104.gd3076383
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz
# cpuid : GenuineIntel,6,42,7
# total memory : 8089800 kB
# cmdline : /home/acme/bin/perf record -e cycles,cache-misses sleep 1 
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0, config2
# = 0x0, excl_usr = 0, excl_kern = 0, id = { 10, 11, 12, 13 }
# event : name = cache-misses, type = 0, config = 0x3, config1 = 0x0,
# config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 14, 15, 16, 17 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
#
# Samples: 19  of event 'cycles'
# Event count (approx.): 2442170
[acme@felicio ~]$ 

I.e. for perf report it is ok already, the user can see what was asked
for, exactly as specified on the command line.

What I discussed with Jiri was that it would be good to have a
programatic way of regenerating the perf_evlist instance from the
perf_event_attr and other feature bits.

I.e. the counterpart to perf_evsel being created from the
perf_event_attr in the perf.data file.

- Arnaldo
