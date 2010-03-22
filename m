Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab0CVMig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab0CVMie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:38:34 -0400
Date: Mon, 22 Mar 2010 12:37:26 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
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
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100322123726.GH21874@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20100321200849.GA51323@dspnet.fr.eu.org> <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk> <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk> <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu> <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu> <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 02:31:49PM +0200, Pekka Enberg wrote:
> On Mon, Mar 22, 2010 at 1:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> What about line number information?  And the source?  Into the kernel with
> >> them as well?
> >
> > Sigh. Please read the _very first_ suggestion i made, which solves all that. I
> > rarely go into discussions without suggesting technical solutions - i'm not
> > interested in flaming, i'm interested in real solutions.
> >
> > Here it is, repeated for the Nth time:
> >
> > Allow a guest to (optionally) integrate its VFS namespace with the host side
> > as well. An example scheme would be:
> >
> >   /guests/Fedora-G1/
> >   /guests/Fedora-G1/proc/
> >   /guests/Fedora-G1/usr/
> >   /guests/Fedora-G1/.../
> >   /guests/OpenSuse-G2/
> >   /guests/OpenSuse-G2/proc/
> >   /guests/OpenSuse-G2/usr/
> >   /guests/OpenSuse-G2/.../
> >
> >  ( This feature would be configurable and would be default-off, to maintain
> >    the current status quo. )
> 
> Heh, funny. That would also solve my number one gripe with
> virtualization these days: how to get files in and out of guests
> without having to install extra packages on the guest side and
> fiddling with mount points on every single guest image I want to play
> with.

FYI, for offline guests, you can use libguestfs[1] to access & change files
inside the guest, and read-only access to running guests files. It provides
access via a interactive shell, APIs in all major languages, and also has a
FUSE mdule to expose it directly in the host VFS.  It could probably be made
to work read-write for running guests too if its agent were installed inside
the guest & leverage the new Virtio-Serial channel for comms (avoiding any
network setup requirements).

Regards,
Daniel

[1] http://libguestfs.org/
-- 
|: Red Hat, Engineering, London    -o-   http://people.redhat.com/berrange/ :|
|: http://libvirt.org -o- http://virt-manager.org -o- http://deltacloud.org :|
|: http://autobuild.org        -o-         http://search.cpan.org/~danberr/ :|
|: GnuPG: 7D3B9505  -o-   F3C9 553F A1DA 4AC2 5648 23C1 B3DF F742 7D3B 9505 :|
