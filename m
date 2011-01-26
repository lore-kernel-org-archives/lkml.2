Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1AZPXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1AZPXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:23:30 -0500
Subject: Re: [PATCH 03/16] KVM-HDR: KVM Userspace registering ioctl
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D403A4F.6090707@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-4-git-send-email-glommer@redhat.com>
	 <4D400180.2080305@redhat.com>
	 <1296044072.15920.48.camel@mothafucka.localdomain>
	 <4D403A4F.6090707@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 13:23:26 -0200
Message-ID: <1296055406.3591.1.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:14 +0200, Avi Kivity wrote:
> On 01/26/2011 02:14 PM, Glauber Costa wrote:
> > On Wed, 2011-01-26 at 13:12 +0200, Avi Kivity wrote:
> > >  On 01/24/2011 08:06 PM, Glauber Costa wrote:
> > >  >  KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
> > >  >  is a piece of shared memory that is visible to both the hypervisor and the guest
> > >  >  kernel - but not the guest userspace.
> > >  >
> > >  >  The basic idea is that the guest can tell the hypervisor about a specific
> > >  >  piece of memory, and what it expects to find in there. This is a generic
> > >  >  abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
> > >  >  handle a specific request, thus giving us flexibility in some features
> > >  >  in the future.
> > >  >
> > >  >  KVM (The hypervisor) can change the contents of this piece of memory at
> > >  >  will. This works well with paravirtual information, and hopefully
> > >  >  normal guest memory - like last update time for the watchdog, for
> > >  >  instance.
> > >  >
> > >  >  This patch contains the header part of the userspace communication implementation.
> > >  >  Userspace can query the presence/absence of this feature in the normal way.
> > >  >  It also tells the hypervisor that it is capable of handling - in whatever
> > >  >  way it chooses, registrations that the hypervisor does not know how to.
> > >  >  In x86, only user so far, this mechanism is implemented as generic userspace
> > >  >  msr exit, that could theorectically be used to implement msr-handling in
> > >  >  userspace.
> > >  >
> > >  >  I am keeping the headers separate to facilitate backports to people
> > >  >  who wants to backport the kernel part but not the hypervisor, or the other way around.
> > >  >
> > >
> > >  Again the protocol is not specified.  How about starting from
> > >  Documentation/kvm/api.txt so we don't have to guess?
> > I will do that in the next version, if the idea is not shoot up
> > completely.
> 
> For some reason people write the code first and the documentation as an 
> afterthought.  If you switch the order, you can get a high level review 
> first, followed by a low-level code review once the high level details 
> are agreed.  Of course it's hard to do major changes this way, since the 
> API often evolves while writing the code.

Thing is, processor runs code, not english. So I guess people write code
first at least to know what works vs what not works before writing a
potentially beautiful-but-only-theoretical novel.

Rest assured, I don't plan to push for merges of any feature before
providing docs.


