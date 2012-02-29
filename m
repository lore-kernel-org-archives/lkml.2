Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030935Ab2B2KT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030771Ab2B2KT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:19:26 -0500
Date: Wed, 29 Feb 2012 10:19:13 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
Message-ID: <20120229101913.GG5050@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F4AF1FB.6000903@cn.fujitsu.com>
 <4F4CB926.6050600@redhat.com>
 <4F4D7F5E.5040202@cn.fujitsu.com>
 <4F4DF4C6.90609@redhat.com>
 <20120229095842.GF5050@redhat.com>
 <4F4DF86C.5010407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F4DF86C.5010407@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:05:32PM +0200, Avi Kivity wrote:
> On 02/29/2012 11:58 AM, Daniel P. Berrange wrote:
> > > 
> > > How about using a virtio-serial channel for this?  You can transfer any
> > > amount of information (including the dump itself).
> >
> > When the guest OS has crashed, any dumps will be done from the host
> > OS using libvirt's core dump mechanism. The guest OS isn't involved
> > and is likely too dead to be of any use anyway. Likewise it is
> > quite probably too dead to work a virtio-serial channel or any
> > similarly complex device. We're really just after the simplest
> > possible notification that the guest kernel has paniced.
> 
> If it's alive enough to panic, it's alive enough to kexec its kdump
> kernel.  After that it can do anything.
> 
> Guest-internal dumps are more useful IMO that host-initiated dumps.  In
> a cloud, the host-initiated dump is left on the host, outside the reach
> of the guest admin, outside the guest image where all the symbols are,
> and sometimes not even on the same host if a live migration occurred. 
> It's more useful in small setups, or if the problem is in the
> hypervisor, not the guest.

I don't think guest vs host dumps should be considered mutually exclusive,
they both have pluses+minuses.

Configuring kexec+kdump requires non-negligable guest admin configuration
work before it's usable, and this work is guest OS specific, if it is possible
at all. A permanent panic notifier that's built in the kernel by default
requires zero guest admin config, and can allow host admin to automate
collection of dumps across all their hosts/guests. The KVM hypercall
notification is fairly trivially ported to any OS kernel, by comparison
with a full virtio + virtio-serial impl.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
