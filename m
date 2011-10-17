Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1JQNeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:34:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1JQNeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:34:44 -0400
Date: Mon, 17 Oct 2011 15:35:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] kvm: set affinity hint for assigned device msi
Message-ID: <20111017133542.GB6406@redhat.com>
References: <cover.1318358229.git.mst@redhat.com>
 <7458f62a58ad7d4022eefba4333336ba268e4ef9.1318358229.git.mst@redhat.com>
 <20111013145450.GA4143@amt.cnet>
 <20111016131223.GB17978@redhat.com>
 <20111017110946.GA21384@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017110946.GA21384@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 09:09:46AM -0200, Marcelo Tosatti wrote:
> On Sun, Oct 16, 2011 at 03:12:23PM +0200, Michael S. Tsirkin wrote:
> > On Thu, Oct 13, 2011 at 11:54:50AM -0300, Marcelo Tosatti wrote:
> > > On Tue, Oct 11, 2011 at 08:38:28PM +0200, Michael S. Tsirkin wrote:
> > > > To forward an interrupt to a vcpu that runs on
> > > > a host cpu different from the current one,
> > > > we need an ipi which likely will cost us as much
> > > > as delivering the interrupt directly to that cpu would.
> > > > 
> > > > Set irq affinity hint to point there, irq balancer
> > > > can then take this into accound and balance
> > > > interrupts accordingly.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >  virt/kvm/assigned-dev.c |    8 +++++---
> > > >  virt/kvm/irq_comm.c     |   17 ++++++++++++++++-
> > > >  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> Or maybe even automatic in-kernel irq affinity disabled by 
> default (to avoid interference with userspace pinning). 

Right. But what's the interface to enable it?
There's no standard interface, is there?

The advantage of hinting is that it works
with existing tools, without changing userspace at all.

> All of that if it makes sense performance wise, of course.

That's the point. Almost any benchmark I'm aware of is run with vcpus
pinned.

-- 
MST
