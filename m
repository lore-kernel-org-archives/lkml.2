Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0IPNo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:44:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0IPNo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:44:26 -0400
Date: Thu, 16 Sep 2010 15:38:28 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
Message-ID: <20100916133828.GA24850@redhat.com>
References: <20100916101339.GK20864@redhat.com>
 <20100916102047.GY3008@redhat.com>
 <20100916104455.GA22254@redhat.com>
 <20100916105403.GZ3008@redhat.com>
 <20100916105352.GB22254@redhat.com>
 <20100916111752.GA3008@redhat.com>
 <20100916121338.GA23779@redhat.com>
 <20100916123301.GE3008@redhat.com>
 <20100916125717.GA24284@redhat.com>
 <4C921823.5080602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C921823.5080602@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 03:14:11PM +0200, Avi Kivity wrote:
>  On 09/16/2010 02:57 PM, Michael S. Tsirkin wrote:
> >>
> >>  >  >  If you want to split parts that asserts irq and de-asserts it then we
> >>  >  >  should have irqfd that tracks line status and knows interrupt line
> >>  >  >  polarity.
> >>  >
> >>  >  Yes, it can know about polarity even though I think it's cleaner to do this
> >>  >  per gsi. But it can not track line status as line is shared with
> >>  >  other devices.
> >>  It should track only device's line status.
> >
> >There is no such thing as device's line status on real hardware, either.
> >Devices do not drive INT# high: they drive it low (all the time)
> >or do not drive it at all.
> >
> 
> That's just an implementation detail.  Devices either assert INT# or
> they do not.  Tying the wires together constitutes an AND gate.
> This gate has to be modelled somewhere, currently it's in qemu's pci
> emulation.

Right. kvm in kernel has this as well, we need to keep this in
kvm kernel if we want to support level with irqfd.
Where it does not belong is individual devices: these
should be able to assert INTx multiple times
and it should have no effect, as per spec.

> -- 
> error compiling committee.c: too many arguments to function
