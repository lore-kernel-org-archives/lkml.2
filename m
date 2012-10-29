Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab2J2Ner (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 09:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757002Ab2J2Neq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 09:34:46 -0400
Date: Mon, 29 Oct 2012 11:33:57 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/5] perf dso: Separate dso symbols to separate object
Message-ID: <20121029133356.GC6754@infradead.org>
References: <1351372712-21104-1-git-send-email-jolsa@redhat.com>
 <87mwz57czf.fsf@sejong.aot.lge.com>
 <20121029111328.GA1123@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029111328.GA1123@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 29, 2012 at 12:13:28PM +0100, Jiri Olsa escreveu:
> On Mon, Oct 29, 2012 at 08:07:48PM +0900, Namhyung Kim wrote:
> > On Sat, 27 Oct 2012 23:18:27 +0200, Jiri Olsa wrote:

> > > separating dso related stuff into dso object plus some other symbol
> > > object cleanup. It's just a code moving, no actual change was done.

> > Looks good to me.

> > Arnaldo, if you want, you can add my Reviewed- or Tested-by tags for this
> > series.

> humm, so you could compile it wth no problem..? what system are you? ;)

util/dso.c:1:20: error: symbol.h: No such file or directory

[acme@sandy linux]$ head -4 tools/perf/util/dso.c 
#include <symbol.h>
#include "dso.h"
#include "util.h"
#include "debug.h"
[acme@sandy linux]$

If I use "symbol.h" it builds, I've fixed this one here, thanks.

The problem is that I use O=, building it without it works.

- ARnaldo
