Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2J1VRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 17:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab2J1VRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 17:17:07 -0400
Date: Sun, 28 Oct 2012 19:16:46 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 5/5] perf tool: Move dso_* related functions into dso
 object
Message-ID: <20121028211646.GB6754@infradead.org>
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
 <1351372712-21104-6-git-send-email-jolsa@redhat.com>
 <20121028133702.GA6754@infradead.org>
 <20121028184200.GB1599@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121028184200.GB1599@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Oct 28, 2012 at 07:42:01PM +0100, Jiri Olsa escreveu:
> On Sun, Oct 28, 2012 at 11:37:02AM -0200, Arnaldo Carvalho de Melo wrote:
> >     CC /home/acme/git/build/perf/util/dso-test-data.o
> > In file included from util/dso.c:2:
> > util/dso.h:87: error: ‘BUILD_ID_SIZE’ undeclared here (not in a function)
> >     CC /home/acme/git/build/perf/util/color.o
> > cc1: warnings being treated as errors
> > util/dso.c: In function ‘dso__binary_type_file’:
> > util/dso.c:45: error: implicit declaration of function ‘filename__read_debuglink’
> > util/dso.c:45: error: nested extern declaration of ‘filename__read_debuglink’
> > util/dso.c:51: error: ‘symbol_conf’ undeclared (first use in this function)
> > util/dso.c:51: error: (Each undeclared identifier is reported only once
> > util/dso.c:51: error: for each function it appears in.)
> > util/dso.c: In function ‘dso__delete’:
> > util/dso.c:435: error: implicit declaration of function ‘symbols__delete’
> > util/dso.c:435: error: nested extern declaration of ‘symbols__delete’
> > util/dso.c: In function ‘dso__read_running_kernel_build_id’:
> > util/dso.c:462: error: implicit declaration of function ‘sysfs__read_build_id’
> > util/dso.c:462: error: nested extern declaration of ‘sysfs__read_build_id’
> > util/dso.c: In function ‘__dsos__read_build_ids’:
> > util/dso.c:500: error: implicit declaration of function ‘filename__read_build_id’
> > util/dso.c:500: error: nested extern declaration of ‘filename__read_build_id’
> > util/dso.c: In function ‘dso__fprintf’:
> > util/dso.c:589: error: dereferencing pointer to incomplete type
> > util/dso.c:589: error: type defaults to ‘int’ in declaration of ‘__mptr’
> > util/dso.c:589: error: initialization from incompatible pointer type
> > util/dso.c:589: error: invalid use of undefined type ‘struct symbol’
> > util/dso.c:590: error: implicit declaration of function ‘symbol__fprintf’
> > util/dso.c:590: error: nested extern declaration of ‘symbol__fprintf’
> > make: *** [/home/acme/git/build/perf/util/dso.o] Error 1
> 
> ugh.. I have it rebased to your perf/core and it builds cleanly
> 
> Any chance there's something not pushed yet?

The only thing besides the four first patches in your series is one that
you acked:

commit 9175ce1f1244edd9f4d39605aa06ce5b0a50b8e0
Author: Andi Kleen <ak@linux.intel.com>
Date:   Fri Oct 26 13:30:06 2012 -0700

    perf tools: Move parse_events error printing to parse_events_options


---------------




[acme@sandy linux]$ cat /etc/redhat-release 
Red Hat Enterprise Linux Server release 6.3 (Santiago)

- Arnaldo
