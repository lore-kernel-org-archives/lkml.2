Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0IPPaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:30:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab0IPPaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:30:10 -0400
Date: Thu, 16 Sep 2010 17:24:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916152411.GE24850@redhat.com>
References: <20100916105352.GB22254@redhat.com>
 <20100916111752.GA3008@redhat.com>
 <20100916121338.GA23779@redhat.com>
 <20100916123301.GE3008@redhat.com>
 <20100916125717.GA24284@redhat.com>
 <20100916131823.GH3008@redhat.com>
 <20100916135137.GB24850@redhat.com>
 <20100916140615.GJ3008@redhat.com>
 <20100916142335.GC24850@redhat.com>
 <20100916145117.GK3008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916145117.GK3008@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 04:51:17PM +0200, Gleb Natapov wrote:
> > > What for? Device emulation should do de-assert.
> > 
> > Sorry, but at this point I have no idea what you call device emulation.
> The same thing everyone calls device emulation. In case of virtio-net it
> is in hw/virtio-net.c. If vhost-net is in use device emulation is split
> between userspace and kernel, but it is still just device emulation.


case in point, virtio net does not know about pci at all,
so it can not deassert.

> > qemu has code to de-assert. vhost has code to assert.
> Good. So qemu will de-assert. So what do you mean by
> "KVM would need to find all irqfd objects mapped to gsi and notify
> them on deassert"
> 
> > I would like to optimize level interrupts and stop driving
> > scheduler insane if at all possible.
> > 
> Worthy goal. Do it in irqfd. Irqfd shouldn't call kvm_set_irq() if irq
> level hasn't changed.

Right. Then it needs to know about deasserts. It does not get this
information, so when kvm gets deassert ioctl it should
locate irqfd object and set level to 0.
See?

-- 
MST

