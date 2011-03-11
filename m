Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1CKCsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:48:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab1CKCsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:48:16 -0500
Date: Thu, 10 Mar 2011 21:47:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: m-ikeda@ds.jp.nec.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        ryov@valinux.co.jp, taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
Message-ID: <20110311024732.GB11710@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110308224325.GK27455@redhat.com>
 <20110308225059.GL27455@redhat.com>
 <AANLkTinpLiFM2yoMONQYekSd4L1BgzHSUa6F+QGbW8Gr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinpLiFM2yoMONQYekSd4L1BgzHSUa6F+QGbW8Gr@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:04:11AM -0800, Justin TerAvest wrote:
> On Tue, Mar 8, 2011 at 2:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Mar 08, 2011 at 05:43:25PM -0500, Vivek Goyal wrote:
> >> On Tue, Mar 08, 2011 at 01:20:50PM -0800, Justin TerAvest wrote:
> >> > This patchset adds tracking to the page_cgroup structure for which cgroup has
> >> > dirtied a page, and uses that information to provide isolation between
> >> > cgroups performing writeback.
> >> >
> >>
> >> Justin,
> >>
> >> So if somebody is trying to isolate a workload which does bunch of READS
> >> and lots of buffered WRITES, this patchset should help in the sense that
> >> all the heavy WRITES can be put into a separate cgroup of low weight?
> >>
> >> Other application which are primarily doing READS, direct WRITES or little
> >> bit of buffered WRITES should still get good latencies if heavy writer
> >> is isolated in a separate group?
> >>
> >> If yes, then this piece standalone can make sense. And once the other
> >> piece/patches of memory cgroup dirty ratio and cgroup aware buffered
> >> writeout come in, then one will be able to differentiate buffered writes
> >> of different groups.
> >
> > Thinking more about it, currently anyway SYNC preempts the ASYNC. So the
> > question would be will it help me enable get better isolation latencies
> > of READS agains buffered WRITES?
> 
> Ah! Sorry, I left out a patch that disables cross-group preemption.
> I'll add that to the patchset and email out v2 soon.

Well, what I was referring to that even in current code sync preempts
all async in CFQ. So it looks like this patchset will not help get
better latencies in presence of WRITES?

The only place it can help is that one is looking for service differentation
between two or more buffered write streams. For that we need to fix
upper layers first.

Vivek
