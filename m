Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab0CVOCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:02:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVOCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:02:36 -0400
Date: Mon, 22 Mar 2010 15:02:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Avi Kivity <avi@redhat.com>,
       Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322140205.GB14201@elte.hu>
References: <4BA68234.1060804@nagafix.co.uk>
 <4BA68997.60406@redhat.com>
 <20100321212009.GE30194@elte.hu>
 <4BA70F9A.8030304@redhat.com>
 <20100322114824.GF3483@elte.hu>
 <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
 <20100322123726.GH21874@redhat.com>
 <20100322125440.GB12475@elte.hu>
 <20100322130513.GJ21874@redhat.com>
 <20100322132326.GA15923@amd.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322132326.GA15923@amd.home.annexia.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard W.M. Jones <rjones@redhat.com> wrote:

> On Mon, Mar 22, 2010 at 01:05:13PM +0000, Daniel P. Berrange wrote:
> > This is close to the way libguestfs already works. It boots QEMU/KVM pointing
> > to a minimal stripped down appliance linux OS image, containing a small agent
> > it talks to over some form of vmchannel/serial/virtio-serial device. Thus the
> > kernel in the appliance it runs is the only thing that needs to know about the
> > filesystem/lvm/dm on-disk formats - libguestfs definitely does not want to be
> > duplicating this detailed knowledge of on disk format itself. It is doing
> > full read-write access to the guest filesystem in offline mode - one of the
> > major use cases is disaster recovery from a unbootable guest OS image.
> 
> As Dan said, the 'daemon' part is separate and could be run as a standard 
> part of a guest install, talking over vmchannel to the host. The only real 
> issue I can see is adding access control to the daemon (currently it doesn't 
> need it and doesn't do any).  Doing it this way you'd be leveraging the 
> ~250,000 lines of existing libguestfs code, bindings in multiple languages, 
> tools etc.

I think it would be a nice option to allow such guest-side "daemon's" to be 
executed in the guest context without _any_ guest-side support.

This would be possible by building such minimal daemons that use vmchannel, 
and which are built for generic x86 (maybe even built for 32-bit x86 so that 
they can run on any x86 distro). They could execute as the init task of any 
guest kernel - Qemu could 'blend in / replace' the binary as the init task of 
the guest temporarily - and some simple bootstrap code could then start the 
daemon and start the real init binary (and turn off the 'blending' of the init 
task).

That way any guest could be extended via such Qemu functionality - even 
without any kernel changes. Has anyone thought about (or coded) such a 
solution perhaps?

	Ingo
