Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762610Ab2FVPcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:32:42 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:59357 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762578Ab2FVPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:32:39 -0400
Date: Fri, 22 Jun 2012 12:32:34 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf
 dependency (v2)
Message-ID: <20120622153234.GJ17747@infradead.org>
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>
 <1340358478.18025.51.camel@twins>
 <1340377510.1478.10.camel@leonhard>
 <4FE48CCA.2050506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FE48CCA.2050506@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jun 22, 2012 at 09:18:34AM -0600, David Ahern escreveu:
> On 6/22/12 9:05 AM, Namhyung Kim wrote:
> >2012-06-22 (금), 11:47 +0200, Peter Zijlstra:
> >>On Fri, 2012-06-22 at 14:37 +0900, Namhyung Kim wrote:
> >>>And then I realized that the perf record needs to know about the
> >>>build-id's anyway. :( So I implemented a poor man's version of elf
> >>>parser only for parsing the build-id info.

> >>Why? the very first versions didn't know about any of that nonsense :-)
> >>It works just fine as long as you don't go change binaries around.
> >>
> >>That said, you did the work already, so no objection, just saying
> >>builtids aren't that important.

> >I'm not sure I understood you correctly. But 'perf record' needs to know
> >about the build-id's to save them to perf.data for 'perf report' later.
> >And 'perf archive' also needs to know about them to select necessary
> >binaries for the session.

> And build-id's are not required for report (-B option for record).

> Also, the intent is for a small footprint binary for embedded
> systems. On such a system I would expect binaries and libraries to
> be stripped, so no point in running perf-archive.

Right, build ids are not a strict requirement, its just a safeguard,
when available, to prevent WTF moments at post processing time (report,
annotate, etc) if different binaries are used to resolve symbols.

- Arnaldo
