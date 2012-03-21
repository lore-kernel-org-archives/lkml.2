Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab2CURSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab2CURR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:17:57 -0400
Date: Wed, 21 Mar 2012 17:04:14 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: minyard@acm.org, Corey Minyard <tcminyard@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Wen Congyang <wency@cn.fujitsu.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120321170413.GD3101@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F66E14F.3040809@cn.fujitsu.com>
 <4F6854F4.3060703@cn.fujitsu.com>
 <20120320154517.GG27928@redhat.com>
 <4F692723.8050904@cn.fujitsu.com>
 <20120321091127.GO22368@redhat.com>
 <4F69FF48.3010200@acm.org>
 <4F6A00EC.3060706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F6A00EC.3060706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 06:25:16PM +0200, Avi Kivity wrote:
> On 03/21/2012 06:18 PM, Corey Minyard wrote:
> >
> >> Look at drivers/char/ipmi/ipmi_msghandler.c. It has code to send panic
> >> event over IMPI. The code is pretty complex. Of course if we a going to
> >> implement something more complex than simple hypercall for panic
> >> notification we better do something more interesting with it than just
> >> saying "panic happened", like sending stack traces on all cpus for
> >> instance.
> >
> > I doubt that's the best example, unfortunately.  The IPMI event log
> > has limited space and it has to be send a little piece at a time since
> > each log entry is 14 bytes.  It just prints the panic string, nothing
> > else.  Not that it isn't useful, it has saved my butt before.
> >
> > You have lots of interesting options with paravirtualization.  You
> > could, for instance, create a console driver that delivered all
> > console output efficiently through a hypercall.  That would be really
> > easy.  Or, as you mention, a custom way to deliver panic information. 
> > Collecting information like stack traces would be harder to
> > accomplish, as I don't think there is currently a way to get it except
> > by sending it to printk.
> 
> That already exists; virtio-console (or serial console emulation) can do
> the job.
> 
> In fact the feature can be implemented 100% host side by searching for a
> panic string signature in the console logs.

You can even go one better and search for the panic string in the
guest memory directly, which is what virt-dmesg does :-)

  http://people.redhat.com/~rjones/virt-dmesg/

Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
