Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945942Ab2CPXOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:14:46 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35549 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161982Ab2CPXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:14:44 -0400
Message-ID: <1331939679.2858.56.camel@dabdike>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Michal Schmidt <mschmidt@redhat.com>
Date: Fri, 16 Mar 2012 23:14:39 +0000
In-Reply-To: <20120313155955.GB7349@google.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>
	 <20120312222817.GI23255@google.com> <20120313140345.GC29169@redhat.com>
	 <20120313155955.GB7349@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 08:59 -0700, Tejun Heo wrote:
> Hey, Vivek.
> 
> On Tue, Mar 13, 2012 at 10:03:45AM -0400, Vivek Goyal wrote:
> > > With root being treated specially, probably as just being a equal
> > > group as other groups, I'm not fully determined about that yet.
> > 
> > So what wrong with flattening the whole hierarchy and all groups being active
> > in the path? It is not worse then second option?
> > 
> >              root
> >        /   |  |  |  \
> >       G1  G2  G3 G31 G32
> 
> It is worse because while there isn't much need for orthogonal
> hierarchies, people often need to apply different limits at different
> levels of the hierarchy for different controllers.  ie. it often
> happens that the distinction between G31 and G32 matters for one
> controller but not for others.  The problem with flattening like you
> suggested above is that it isn't a hierarchy at all - membership isn't
> recursive.
> 
> Imposing limits at single level is an additional restriction and may
> cause some config complexity but it'll be at least explicit and can
> co-exist with full hierarchy in meaningful way.

Isn't there a simple fix for this?  Each controller can decide whether
to pay attention to its cgroup parent in calculating the resource limits
or counting usage.  If the controller elects not to pay attention to its
parents when counting resources and enforcing limits, it effectively
gives you a flat hierarchy from the point of view of the controller.

What actually happens depends on how the controller calculates the
limits: if it's a global fraction, then it's completely flat, if it's
just an absolute limit, then it wouldn't pay attention to the parent
anyway, if it's a proportion, then the controller has to decide how to
divide up the parent's allocation.

James


