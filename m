Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab1DYNkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:40:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:19763 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758152Ab1DYNkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:40:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,265,1301900400"; 
   d="scan'208";a="425033731"
Subject: Re: [PATCH] perf: Allow set output buffer for tasks in the same
 thread group
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tim Blechmann <tim@klingt.org>, David Ahern <dsahern@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1303664726.20212.1.camel@twins>
References: <1303657064.2239.25.camel@localhost>
	 <1303664726.20212.1.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Apr 2011 21:40:38 +0800
Message-Id: <1303738838.2578.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-25 at 01:05 +0800, Peter Zijlstra wrote:
> On Sun, 2011-04-24 at 22:57 +0800, Lin Ming wrote:
> > Currently, kernel only allows an event to redirect its output to other
> > events of the same task.
> > 
> > This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
> > trying to redirect its output to other events in the same thread group.
> 
> Which is exactly what it should do, you should never be allowed to
> redirect your events to that of another task, since that other task
> might be running on another CPU.
> 
> The buffer code strictly assumes no concurrency, therefore its either
> one task or one CPU.

Well, this is not the right fix, then the perf tool code need to be
fixed.


