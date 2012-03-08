Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2CHPjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:39:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62747 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2CHPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:39:42 -0500
Date: Thu, 8 Mar 2012 16:39:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Tom Zanussi <tzanussi@gmail.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 2/2] perf: Add a new sort order: SORT_INCLUSIVE
Message-ID: <20120308153933.GD7976@somewhere.redhat.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
 <1331160079-13821-3-git-send-email-asharma@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331160079-13821-3-git-send-email-asharma@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:41:19PM -0800, Arun Sharma wrote:
> Each entry that used to get added once to the histogram, now is added
> chain->nr times, each time with one less entry in the
> callchain.
> 
> This will result in a non-leaf function that appears in a lot of
> samples to get a histogram entry with lots of hits.
> 
> The user can then drill down into the callchains of functions that
> have high inclusive times.

I don't yet understand the point of this.

Imagine those three hists:

a -> b -> c
a -> b -> d
a-> e -> f

The fractal inverted mode (-G) will report this:

a--
  |
  ----- b
  |     |
  |     -----c
  |     |
  |     -----d
  |
  ----- e
        |
        -----f

The branch sorting is recursive so outstanding callers appear
in the first branches already.

So if your goal is to find important callers, I don't see why
the existing functionalities aren't enough.
