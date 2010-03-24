Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0CXP1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0CXP1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:27:21 -0400
Date: Wed, 24 Mar 2010 15:26:53 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100324152653.GA12225@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <4BA99BCB.5080501@redhat.com> <20100324115900.GB14800@8bytes.org> <4BAA00B1.20407@redhat.com> <20100324125043.GC14800@8bytes.org> <4BAA0DFE.1080700@redhat.com> <20100324134642.GD14800@8bytes.org> <4BAA1A53.20207@redhat.com> <20100324150137.GE14800@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324150137.GE14800@8bytes.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 04:01:37PM +0100, Joerg Roedel wrote:
> >> An approach like: "The files are owned and only readable by the same
> >> user that started the vm." might be a good start. So a user can measure
> >> its own guests and root can measure all of them.
> >
> > That's not how sVirt works.  sVirt isolates a user's VMs from each  
> > other, so if a guest breaks into qemu it can't break into other guests  
> > owned by the same user.
> 
> If a vm breaks into qemu it can access the host file system which is the
> bigger problem. In this case there is no isolation anymore. From that
> context it can even kill other VMs of the same user independent of a
> hypothetical /sys/kvm/.

No it can't. With sVirt every single VM has a custom security label and
the policy only allows it access to disks / files with a matching label,
and prevents it attacking any other VMs or processes on the host. THis
confines the scope of any exploit in QEMU to those resources the admin
has explicitly assigned to the guest.

Regards,
Daniel
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
