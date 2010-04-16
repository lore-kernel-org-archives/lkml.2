Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab0DPKkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 06:40:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:53208 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab0DPKke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 06:40:34 -0400
Subject: Re: VM performance issue in KVM guests.
From: Peter Zijlstra <peterz@infradead.org>
To: vatsa@in.ibm.com
Cc: Avi Kivity <avi@redhat.com>, Srivatsa Vaddagiri <vatsa.ml@gmail.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100415164313.GF9128@linux.vnet.ibm.com>
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>
	 <4BC0D125.9050108@redhat.com>
	 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>
	 <4BC2C07B.4040607@redhat.com>
	 <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>
	 <4BC6CBE3.8020207@redhat.com> <1271338398.1674.13.camel@laptop>
	 <20100415164313.GF9128@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Apr 2010 12:40:36 +0200
Message-ID: <1271414436.4807.1935.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 09:43 -0700, Srivatsa Vaddagiri wrote:
> On Thu, Apr 15, 2010 at 03:33:18PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-04-15 at 11:18 +0300, Avi Kivity wrote:
> > > 
> > > Certainly that has even greater potential for Linux guests.  Note that 
> > > we spin on mutexes now, so we need to prevent preemption while the lock 
> > > owner is running. 
> > 
> > either that, or disable spinning on (para) virt kernels. Para virt
> > kernels could possibly extend the thing by also checking to see if the
> > owner's vcpu is running.
> 
> I suspect we will need a combination of both approaches, given that we will not
> be able to avoid preempting guests in their critical section always (too long
> critical sections or real-time tasks wanting to preempt). Other idea is to
> gang-schedule VCPUs of the same guest as much as possible?

Except gang scheduling is a scalability nightmare waiting to happen. I
much prefer this hint thing.
