Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab2FLLId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:08:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33429 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FLLIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:08:32 -0400
Message-ID: <1339499306.31548.75.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hi3766691@gmail.com, Hillf Danton <dhillf@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Zhouping Liu <zliu@redhat.com>
Date: Tue, 12 Jun 2012 13:08:26 +0200
In-Reply-To: <1339496836.31548.68.camel@twins>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
	 <1339421268.30462.15.camel@twins> <4FD6BD72.2070808@redhat.com>
	 <1339490988.31548.40.camel@twins>
	 <CA+55aFw=akW7B+vRkQRMojnP6_b1YXdKpNEjQ2EyBHcTe2_XLw@mail.gmail.com>
	 <1339496836.31548.68.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 12:27 +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 13:20 +0300, Linus Torvalds wrote:
> > Peter, you are very fundamentally wrong if you think the distance
> > array has to be symmetric. That is fundamentally not true for many
> > typologies.
> > 
> > The trivial example of a non symmetric case is just a simple
> > unidirectional ring. The distance from n to n+1 is just one, but the
> > distance from n+1 to n is n-1 hops.
> > 
> > So don't try to say that distances have to be symmetric. That's just
> > garbage. 
> 
> Sure, I realize this, but the 17,18 thing isn't a ring. It looks like
> something that should be symmetric but isn't.

Not a unidirectional one that is.. I played around a bit more and found
a shape that isn't too odd:


                  2
                /   \
              0       5
             /      /  \
            1 --- / --- 3
             \  /      /
              4       6
                \   /
                  7 


I would've crossed 0<->6 instead of 1<->3 so the 2/3 connected nodes are
spread better, but what do I know.

The only really odd thing is the numbering, which is what threw me.

But yeah, the possibility of uni-directional rings makes detecting
obvious crack tables harder, which is why I haven't got it -- yet.
