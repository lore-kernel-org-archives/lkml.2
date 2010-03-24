Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab0CXQqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:46:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0CXQqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:46:20 -0400
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
From: Peter Zijlstra <peterz@infradead.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20100324162343.GK14800@8bytes.org>
References: <20100323182153.GA14800@8bytes.org>
	 <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org>
	 <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org>
	 <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org>
	 <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org>
	 <1269446622.5109.388.camel@twins>  <20100324162343.GK14800@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 17:45:59 +0100
Message-ID: <1269449159.5109.454.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 17:23 +0100, Joerg Roedel wrote:
> On Wed, Mar 24, 2010 at 05:03:42PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-03-24 at 16:01 +0100, Joerg Roedel wrote:
> > 
> > > What I meant was: perf-kernel puts the guest-name into every sample and
> > > perf-userspace accesses /sys/kvm/guest_name/fs/ later to resolve the
> > > symbols. I leave the question of how the guest-fs is exposed to the host
> > > out of this discussion. We should discuss this seperatly.
> > 
> > I'd much prefer a pid like suggested later, keeps the samples smaller.
> > 
> > But that said, we need guest kernel events like mmap and context
> > switches too, otherwise we simply can't make sense of guest userspace
> > addresses, we need to know the guest address space layout.
> 
> With the filesystem approach all we need is the pid of the guest
> process. Then we can access proc/<pid>/maps of the guest and read out the
> address space layout, no?

No, what if it maps new things after you read it? But still getting the
pid of the guest process seems non trivial without guest kernel support.
