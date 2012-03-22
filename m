Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2CVHdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 03:33:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab2CVHda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 03:33:30 -0400
Date: Thu, 22 Mar 2012 09:33:24 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, "Daniel P. Berrange" <berrange@redhat.com>,
        kvm list <kvm@vger.kernel.org>, Jan Kiszka <jan.kiszka@siemens.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
Message-ID: <20120322073324.GZ22368@redhat.com>
References: <4F58664D.1070800@cn.fujitsu.com>
 <4F58943E.1050402@redhat.com>
 <4F595B31.9090301@cn.fujitsu.com>
 <4F5DBC26.7060204@cn.fujitsu.com>
 <4F5DD0FD.9070904@redhat.com>
 <20120313091843.GB3800@redhat.com>
 <4F5F25BF.7060100@redhat.com>
 <4F6A2642.1060107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6A2642.1060107@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 02:04:34PM -0500, Anthony Liguori wrote:
> On 03/13/2012 05:47 AM, Avi Kivity wrote:
> >On 03/13/2012 11:18 AM, Daniel P. Berrange wrote:
> >>On Mon, Mar 12, 2012 at 12:33:33PM +0200, Avi Kivity wrote:
> >>>On 03/12/2012 11:04 AM, Wen Congyang wrote:
> >>>>Do you have any other comments about this patch?
> >>>>
> >>>
> >>>Not really, but I'm not 100% convinced the patch is worthwhile.  It's
> >>>likely to only be used by Linux, which has kexec facilities, and you can
> >>>put talk to management via virtio-serial and describe the crash in more
> >>>details than a simple hypercall.
> >>
> >>As mentioned before, I don't think virtio-serial is a good fit for this.
> >>We want something that is simple&  guaranteed always available. Using
> >>virtio-serial requires significant setup work on both the host and guest.
> >
> >So what?  It needs to be done anyway for the guest agent.
> >
> >>Many management application won't know to make a vioserial device available
> >>to all guests they create.
> >
> >Then they won't know to deal with the panic event either.
> >
> >>Most administrators won't even configure kexec,
> >>let alone virtio serial on top of it.
> >
> >It should be done by the OS vendor, not the individual admin.
> >
> >>The hypercall requires zero host
> >>side config, and zero guest side config, which IMHO is what we need for
> >>this feature.
> >
> >If it was this one feature, yes.  But we keep getting more and more
> >features like that and we bloat the hypervisor.  There's a reason we
> >have a host-to-guest channel, we should use it.
> 
> The problem is that virtio-serial sucks for something like this.
> 
How do we know if we haven't tried :)

> We have two options I think:
> 
> 1) We could reserve a portion of the hypercall space to be deferred
> to userspace for stuff like this.
> 
> 2) We could invent a new hypercall like facility that was less
> bloated than virtio-serial for stuff like this using MMIO/PIO.
> 
> Regards,
> 
> Anthony Liguori
> 
> >

--
			Gleb.
