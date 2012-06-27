Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2F0O50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2F0O5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:57:25 -0400
Date: Wed, 27 Jun 2012 15:57:09 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 5/6 v5] deal with guest panicked event
 accoring to -onpanic parameter
Message-ID: <20120627145709.GK31414@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4FEAAE6E.7070302@cn.fujitsu.com>
 <4FEAAFFF.40401@cn.fujitsu.com>
 <20120627165232.77a97fd0@BR9GNB5Z>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120627165232.77a97fd0@BR9GNB5Z>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 04:52:32PM +0200, Cornelia Huck wrote:
> On Wed, 27 Jun 2012 15:02:23 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
> > When the guest is panicked, it will write 0x1 to the port KVM_PV_PORT.
> > So if qemu reads 0x1 from this port, we can do the folloing three
> > things according to the parameter -onpanic:
> > 1. emit QEVENT_GUEST_PANICKED only
> > 2. emit QEVENT_GUEST_PANICKED and pause the guest
> > 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
> > 4. emit QEVENT_GUEST_PANICKED and reset the guest
> 
> Would it be useful to add some "dump the guest" actions here?

Better off leaving that to the mgmt layer using QEMU. If you
tried to directly handle "dump the guest" in the context of
the panic notifier then you add all sorts of extra complexity
to this otherwise simple feature. For a start the you need to
tell it what filename to use, which is not something you can
necessarily decide at the time QEMU starts - you might want
a separate filename each time a panic ocurrs. THe mgmt app
might not even want QEMU to dump to a file - it might want
to use a socket, or pass in a file descriptor at time of
dump. All in all, it is better to keep the panic notifier
simple, and let the mgmt app then decide whether to take
a dump separately, using existing QEMU monitor commands
and features.

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
