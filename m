Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896Ab2BJSnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:43:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:35084 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2BJSnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:43:20 -0500
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4F205D1D.1020304@fb.com>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
	 <1327318449.2446.5.camel@twins> <4F1DA9D0.6090208@fb.com>
	 <1327352631.2446.22.camel@twins> <4F1DE6FE.4000603@fb.com>
	 <1327415255.2614.33.camel@laptop> <4F1F26CC.4040109@fb.com>
	 <20120125092008.GB20878@somewhere>  <4F205D1D.1020304@fb.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 19:43:03 +0100
Message-ID: <1328899383.25989.40.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-25 at 11:50 -0800, Arun Sharma wrote:
> # perf record -agP -e sched:sched_switch --filter "prev_state == 1 || 
> prev_state == 2" -e  sched:sched_stat_sleep -- sleep 3 

Problem with that is it'll try and do a backtrace for all events, not
only the sched_switch but also sched_stat_sleep, which is completely
superfluous (and expensive).

Currently perf tool doesn't support individual -g flags though and its
slightly non-trivial to make it so. Easiest work-around would be two
records and then merge the two files.

