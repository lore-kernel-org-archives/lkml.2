Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab1KGRRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:17:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814Ab1KGRRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:17:22 -0500
Date: Mon, 7 Nov 2011 19:17:02 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107171702.GA11367@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320676609.18053.44.camel@twins>
 <20111107152540.GF8670@redhat.com>
 <1320684314.17809.29.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320684314.17809.29.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 05:45:14PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-11-07 at 17:25 +0200, Gleb Natapov wrote:
> > > Since the below programming doesn't use perf_event_attr::pinned, yes.
> > > 
> > Yes, that is on todo :). Actually I do want to place all guest perf
> > counters into the same event group and make it pinned. But currently perf
> > event groups are not very flexible. In our usage scenario we can't have
> > one event as a group leader since events are created and destroyed very
> > dynamically. What I would like is to have something like meta event that
> > will group all other real event. 
> 
> Is there a reason to have them grouped if you pin them all anyway?
Hmm good question. May be we shouldn't pin then since this will prevent
profiling vcpu task on a host while perf is running in a guest, but then
we need to group guest created event to get meaningful result. I think I'll
pin them for now and will look into grouping them later.

--
			Gleb.
