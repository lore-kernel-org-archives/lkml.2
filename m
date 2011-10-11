Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1JKU7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:59:53 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49699 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1JKU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:59:52 -0400
Date: Tue, 11 Oct 2011 13:54:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satoru Moriya <satoru.moriya@hds.com>
Cc: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
Message-Id: <20111011135445.f580749b.akpm@linux-foundation.org>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com>
	<20110901100650.6d884589.rdunlap@xenotime.net>
	<20110901152650.7a63cb8b@annuminas.surriel.com>
	<alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com>
	<20111010153723.6397924f.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com>
	<20111011125419.2702b5dc.akpm@linux-foundation.org>
	<65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011 16:23:22 -0400
Satoru Moriya <satoru.moriya@hds.com> wrote:

> On 10/11/2011 03:55 PM, Andrew Morton wrote:
> > On Tue, 11 Oct 2011 15:32:11 -0400
> > Satoru Moriya <satoru.moriya@hds.com> wrote:
> > 
> >> On 10/10/2011 06:37 PM, Andrew Morton wrote:
> >>> On Fri, 7 Oct 2011 20:08:19 -0700 (PDT) David Rientjes 
> >>> <rientjes@google.com> wrote:
> >>>
> >>>> On Thu, 1 Sep 2011, Rik van Riel wrote:
> >>
> >> Actually page allocator decreases min watermark to 3/4 * min 
> >> watermark for rt-task. But in our case some applications create a lot 
> >> of processes and if all of them are rt-task, the amount of watermark
> >> bonus(1/4 * min watermark) is not enough.
> >>
> >> If we can tune the amount of bonus, it may be fine. But that is 
> >> almost all same as extra free kbytes.
> > 
> > This situation is detectable at runtime.  If realtime tasks are being 
> > stalled in the page allocator then start to increase the free-page 
> > reserves.  A little control system.
> 
> Detecting at runtime is too late for some latency critical systems.
> At that system, we must avoid a stall before it happens.

It's pretty darn obvious that the kernel can easily see the situation
developing before it happens.  By comparing a few integers.

Look, please don't go bending over backwards like this to defend a bad
patch.  It's a bad patch!  It would be better not to have to merge it. 
Let's do something better.

> Also, if we increase the free-page reserves a.k.a min_free_kbytes,
> the possibility of direct reclaim on other workloads increases.
> I think it's a bad side effect.

extra_free_kbytes has the same side-effect.
