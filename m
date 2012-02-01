Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab2BAOcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2BAOcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:32:13 -0500
Date: Wed, 1 Feb 2012 15:31:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, acme@redhat.com,
        mingo@elte.hu, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
Message-ID: <20120201143137.GD1655@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-6-git-send-email-jolsa@redhat.com>
 <4F231256.8080905@linux.vnet.ibm.com>
 <20120130095223.GB1552@m.brq.redhat.com>
 <4F289486.2050107@linux.vnet.ibm.com>
 <20120201131340.GC1655@m.brq.redhat.com>
 <1328105932.2662.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328105932.2662.5.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:18:52PM +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-01 at 14:13 +0100, Jiri Olsa wrote:
> > > Are you are suggesting that a single event could use multiple groups
> > > because they may share some common fields, such as the event code?  If
> > > so, I think that might be confusing.   I think it would be better to
> > > have every group fully lay out the bits in the config{,1,2} fields so
> > > that you only need to specify one group per event, even if that leads to
> > > some redundancy (e.g. group1..n all have an eventcode field.)
> > 
> > ok, it'd be the 'cpu::group1/config=1,config1=2,config2=3/u' then..
> > 
> > but let's see what Peter thinks about this, since he first suggested
> > to 'fix' this by having separate pmu drivers.. not format groups :) 
> 
> I'm not convinced we need the whole grouping thing. Even x86 might have
> overlapping definitions, even for a single PMU (config1 contents will
> radically differ depending on the actual events used for instance).

well, I think let's go with what we have now, and see if need/want
to care about format groups later after we use it for a while..

since the "cpu/..../" syntax is new interface, there should be no
problem to change it

> 
> All we should do is warn the user when overlapping masks are used in a
> single event definition and other than that just do as they tell us.

that should be no problem..
do you want it in to take this.. ooor is later ok ;)

jirka

> 
> PMUs can always do an informal namespace thing if really needed, eg. by
> using a consistent prefix.
> 
