Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2HNI4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab2HNI4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:56:32 -0400
Date: Tue, 14 Aug 2012 09:56:19 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH v8] kvm: notify host when the guest is panicked
Message-ID: <20120814085619.GA32708@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <5021D235.4050800@cn.fujitsu.com>
 <20120813182132.GB25268@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120813182132.GB25268@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:21:32PM -0300, Marcelo Tosatti wrote:
> On Wed, Aug 08, 2012 at 10:43:01AM +0800, Wen Congyang wrote:
> > We can know the guest is panicked when the guest runs on xen.
> > But we do not have such feature on kvm.
> > 
> > Another purpose of this feature is: management app(for example:
> > libvirt) can do auto dump when the guest is panicked. If management
> > app does not do auto dump, the guest's user can do dump by hand if
> > he sees the guest is panicked.
> > 
> > We have three solutions to implement this feature:
> > 1. use vmcall
> > 2. use I/O port
> > 3. use virtio-serial.
> > 
> > We have decided to avoid touching hypervisor. The reason why I choose
> > choose the I/O port is:
> > 1. it is easier to implememt
> > 2. it does not depend any virtual device
> > 3. it can work when starting the kernel
> 
> How about searching for the "Kernel panic - not syncing" string 
> in the guests serial output? Say libvirtd could take an action upon
> that?

No, this is not satisfactory. It depends on the guest OS being
configured to use the serial port for console output which we
cannot mandate, since it may well be required for other purposes.


Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
