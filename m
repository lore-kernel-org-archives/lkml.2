Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab0KJOtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:49:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:11541 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab0KJOtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:49:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,178,1288594800"; 
   d="scan'208";a="676145403"
Subject: Re: [RFC PATCH 1/2] perf: Enable group siblings on exec if
 attr::enable_on_exec set
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289399915.2191.127.camel@laptop>
References: <1289369711.2430.38.camel@minggr.sh.intel.com>
	 <1289391586.2191.100.camel@laptop>  <1289398677.2479.10.camel@localhost>
	 <1289399915.2191.127.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 22:49:03 +0800
Message-Id: <1289400543.2479.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 22:38 +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-10 at 22:17 +0800, Lin Ming wrote:
> > On Wed, 2010-11-10 at 20:19 +0800, Peter Zijlstra wrote:
> > > On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> > > > Currently, only group leader is enabled on exec.
> > > 
> > > That's enough, right? If all sibling events are already enabled enabling
> > > the group leader makes the whole thing go.
> > 
> > No.
> > 
> > If the event group is disabled by default("perf stat" case) and will be
> > enabled at next exec, then actually only the group leader will be
> > enabled , because all siblings are explicitly disabled(->state ==
> > PERF_EVENT_STATE_OFF). So the siblings will never be enabled.
> 
> Right, so what I was saying is, don't disable all the siblings by
> default, so that only the group leader will be disabled. In that case
> nothing will get scheduled because the group leader is not enabled.
> 
> So: {disabled, enabled, enabled} will not actually get scheduled and the
> group as a whole is effectively disabled. Once the enabled_on_exec flips
> the group leader to 'enabled' the whole group becomes enabled.
> 
> I don't mind the patch too much (although I would like to avoid that
> double sibling iteration in both group_enable_on_exec() and
> __perf_event_mark_enabled()), but I think it can already work as is.

I got it now!

Another stupid patch, sorry.


