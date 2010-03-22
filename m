Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0CVNYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:24:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab0CVNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:24:35 -0400
Date: Mon, 22 Mar 2010 13:23:26 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Avi Kivity <avi@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
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
Message-ID: <20100322132326.GA15923@amd.home.annexia.org>
References: <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu> <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com> <20100322123726.GH21874@redhat.com> <20100322125440.GB12475@elte.hu> <20100322130513.GJ21874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322130513.GJ21874@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 01:05:13PM +0000, Daniel P. Berrange wrote:
> This is close to the way libguestfs already works. It boots QEMU/KVM pointing
> to a minimal stripped down appliance linux OS image, containing a small agent
> it talks to over some form of vmchannel/serial/virtio-serial device. Thus the
> kernel in the appliance it runs is the only thing that needs to know about the
> filesystem/lvm/dm on-disk formats - libguestfs definitely does not want to be
> duplicating this detailed knowledge of on disk format itself. It is doing
> full read-write access to the guest filesystem in offline mode - one of the
> major use cases is disaster recovery from a unbootable guest OS image.

As Dan said, the 'daemon' part is separate and could be run as a
standard part of a guest install, talking over vmchannel to the host.
The only real issue I can see is adding access control to the daemon
(currently it doesn't need it and doesn't do any).  Doing it this way
you'd be leveraging the ~250,000 lines of existing libguestfs code,
bindings in multiple languages, tools etc.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
