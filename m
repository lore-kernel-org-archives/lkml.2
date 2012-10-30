Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab2J3Pxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 11:53:46 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:53038 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933813Ab2J3Pxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 11:53:44 -0400
Date: Tue, 30 Oct 2012 08:53:38 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 1/9] perf python: add ui stubs file
Message-ID: <20121030155338.GA28061@ghostprotocols.net>
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
 <1351528309-87705-2-git-send-email-dsahern@gmail.com>
 <87a9v4777t.fsf@sejong.aot.lge.com>
 <508FE808.2030306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508FE808.2030306@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 30, 2012 at 08:45:28AM -0600, David Ahern escreveu:
> On 10/30/12 1:24 AM, Namhyung Kim wrote:
> >On Mon, 29 Oct 2012 10:31:41 -0600, David Ahern wrote:
> >>stdio based implementations of ui_xxxx based functions for the python
> >>library. Needed for patch 3 - consolidating open counters method.

> >How about adding ui/util.c to the python-ext-sources?

> Handles some of the ui_xxxx functions, but still missing some
> symbols -- verbose, eprintf, ui__error_paranoid. The point of the
> python_stubs.c was a short term solution for the ui handlers.
> Arnaldo had some ideas on what is really needed.

Yes, and that is something like what Namhyung did for perf_target, i.e.
don't call ui__ stuff from the evsel/evlist classes but use a
perf_evlist__strerror, merge perf_evlist__open_counters() with
perf_evlist__open(), use just perf_evlist__open() everywhere, so that
all tools get the fallbacks for features not present in older kernels,
etc.

- Arnaldo
