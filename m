Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1FSIPQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 04:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1FSIPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 04:15:13 -0400
Date: Sun, 19 Jun 2011 11:15:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Asias He <asias.hejun@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110619081506.GA8744@redhat.com>
References: <1308153214.7566.6.camel@jaguar>
 <20110616142859.GA18356@redhat.com>
 <4DFA1AC2.20605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DFA1AC2.20605@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 11:01:22PM +0800, Asias He wrote:
> On 06/16/2011 10:28 PM, Michael S. Tsirkin wrote:
> > On Wed, Jun 15, 2011 at 06:53:34PM +0300, Pekka Enberg wrote:
> >> Hi all,
> >>
> >> We’re proud to announce the second version of the Native Linux KVM tool! We’re
> >> now officially aiming for merging to mainline in 3.1.
> >>
> >> Highlights:
> >>
> >> - Experimental GUI support using SDL and VNC
> >>
> >> - SMP support. tools/kvm/ now has a highly scalable, largely lockless driver
> >>   interface and the individual drivers are using finegrained locks.
> >>
> >> - TAP-based virtio networking
> > 
> > Wanted to ask for a while: would it make sense to use vhost-net?
> > Or maybe use that exclusively?
> > Less hypervisor code to support would help the focus.
> > 
> 
> Sure. We are planning to use vhost-net. Just out of time right now, we
> are currently working on simple user model network support which allows
> plain user to use network without root privilege.

Yes, qemu does this by implementing NAT and the
TCP stack in userspace.  What always made me unhappy
about this solution is that we have a perfectly fine NAT and TCP
in kernel, we just lack APIs to make an unpriveledged
user make use of it the way we want.
I hope you can avoid this duplication.

Another question is whether you want to implement a dhcp server.

-- 
MST
