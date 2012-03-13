Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889Ab2CMJS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013Ab2CMJS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:18:56 -0400
Date: Tue, 13 Mar 2012 09:18:43 +0000
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120313091843.GB3800@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F58943E.1050402@redhat.com>
 <4F595B31.9090301@cn.fujitsu.com>
 <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F5DD0FD.9070904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> On 03/12/2012 11:04 AM, Wen Congyang wrote:
> > Do you have any other comments about this patch?
> >
> 
> Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> likely to only be used by Linux, which has kexec facilities, and you can
> put talk to management via virtio-serial and describe the crash in more
> details than a simple hypercall.

As mentioned before, I don't think virtio-serial is a good fit for this.
We want something that is simple & guaranteed always available. Using
virtio-serial requires significant setup work on both the host and guest.
Many management application won't know to make a vioserial device available
to all guests they create. Most administrators won't even configure kexec,
let alone virtio serial on top of it. The hypercall requires zero host
side config, and zero guest side config, which IMHO is what we need for
this feature.


Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
