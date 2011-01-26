Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1AZPO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:14:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab1AZPO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:14:28 -0500
Message-ID: <4D403A4F.6090707@redhat.com>
Date: Wed, 26 Jan 2011 17:14:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH 03/16] KVM-HDR: KVM Userspace registering ioctl
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>	 <1295892397-11354-4-git-send-email-glommer@redhat.com>	 <4D400180.2080305@redhat.com> <1296044072.15920.48.camel@mothafucka.localdomain>
In-Reply-To: <1296044072.15920.48.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 02:14 PM, Glauber Costa wrote:
> On Wed, 2011-01-26 at 13:12 +0200, Avi Kivity wrote:
> >  On 01/24/2011 08:06 PM, Glauber Costa wrote:
> >  >  KVM, which stands for KVM Virtual Memory (I wanted to call it KVM Virtual Mojito),
> >  >  is a piece of shared memory that is visible to both the hypervisor and the guest
> >  >  kernel - but not the guest userspace.
> >  >
> >  >  The basic idea is that the guest can tell the hypervisor about a specific
> >  >  piece of memory, and what it expects to find in there. This is a generic
> >  >  abstraction, that goes to userspace (qemu) if KVM (the hypervisor) can't
> >  >  handle a specific request, thus giving us flexibility in some features
> >  >  in the future.
> >  >
> >  >  KVM (The hypervisor) can change the contents of this piece of memory at
> >  >  will. This works well with paravirtual information, and hopefully
> >  >  normal guest memory - like last update time for the watchdog, for
> >  >  instance.
> >  >
> >  >  This patch contains the header part of the userspace communication implementation.
> >  >  Userspace can query the presence/absence of this feature in the normal way.
> >  >  It also tells the hypervisor that it is capable of handling - in whatever
> >  >  way it chooses, registrations that the hypervisor does not know how to.
> >  >  In x86, only user so far, this mechanism is implemented as generic userspace
> >  >  msr exit, that could theorectically be used to implement msr-handling in
> >  >  userspace.
> >  >
> >  >  I am keeping the headers separate to facilitate backports to people
> >  >  who wants to backport the kernel part but not the hypervisor, or the other way around.
> >  >
> >
> >  Again the protocol is not specified.  How about starting from
> >  Documentation/kvm/api.txt so we don't have to guess?
> I will do that in the next version, if the idea is not shoot up
> completely.

For some reason people write the code first and the documentation as an 
afterthought.  If you switch the order, you can get a high level review 
first, followed by a low-level code review once the high level details 
are agreed.  Of course it's hard to do major changes this way, since the 
API often evolves while writing the code.

-- 
error compiling committee.c: too many arguments to function

