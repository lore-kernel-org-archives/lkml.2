Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366Ab2B2J6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:58:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2B2J6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:58:53 -0500
Date: Wed, 29 Feb 2012 09:58:42 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
Message-ID: <20120229095842.GF5050@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F4AF1FB.6000903@cn.fujitsu.com>
 <4F4CB926.6050600@redhat.com>
 <4F4D7F5E.5040202@cn.fujitsu.com>
 <4F4DF4C6.90609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F4DF4C6.90609@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:49:58AM +0200, Avi Kivity wrote:
> On 02/29/2012 03:29 AM, Wen Congyang wrote:
> > At 02/28/2012 07:23 PM, Avi Kivity Wrote:
> > > On 02/27/2012 05:01 AM, Wen Congyang wrote:
> > >> We can know the guest is paniced when the guest runs on xen.
> > >> But we do not have such feature on kvm. This patch implemnts
> > >> this feature, and the implementation is the same as xen:
> > >> register panic notifier, and call hypercall when the guest
> > >> is paniced.
> > > 
> > > What's the motivation for this?  "Xen does this" is insufficient.
> >
> > Another purpose is: management app(for example: libvirt) can do auto
> > dump when the guest is crashed. If management app does not do auto
> > dump, the guest's user can do dump by hand if he sees the guest is
> > paniced.
> >
> > I am thinking about another status: dumping. This status tells
> > the guest's user that the guest is paniced, and the OS's dump function
> > is working.
> >
> > These two status can tell the guest's user whether the guest is pancied,
> > and what should he do if the guest is paniced.
> >
> 
> How about using a virtio-serial channel for this?  You can transfer any
> amount of information (including the dump itself).

When the guest OS has crashed, any dumps will be done from the host
OS using libvirt's core dump mechanism. The guest OS isn't involved
and is likely too dead to be of any use anyway. Likewise it is
quite probably too dead to work a virtio-serial channel or any
similarly complex device. We're really just after the simplest
possible notification that the guest kernel has paniced.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
