Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0IPNuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0IPNun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:50:43 -0400
Message-ID: <4C9220A9.4070508@redhat.com>
Date: Thu, 16 Sep 2010 15:50:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
References: <20100916101339.GK20864@redhat.com> <20100916102047.GY3008@redhat.com> <20100916104455.GA22254@redhat.com> <20100916105403.GZ3008@redhat.com> <20100916105352.GB22254@redhat.com> <20100916111752.GA3008@redhat.com> <20100916121338.GA23779@redhat.com> <20100916123301.GE3008@redhat.com> <20100916125717.GA24284@redhat.com> <4C921823.5080602@redhat.com> <20100916133828.GA24850@redhat.com>
In-Reply-To: <20100916133828.GA24850@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/16/2010 03:38 PM, Michael S. Tsirkin wrote:
> >
> >  That's just an implementation detail.  Devices either assert INT# or
> >  they do not.  Tying the wires together constitutes an AND gate.
> >  This gate has to be modelled somewhere, currently it's in qemu's pci
> >  emulation.
>
> Right. kvm in kernel has this as well, we need to keep this in
> kvm kernel if we want to support level with irqfd.

Right, we added the irq_source_id hack for device assignment.

What's wrong with letting userspace mediate this, though?

> Where it does not belong is individual devices: these
> should be able to assert INTx multiple times
> and it should have no effect, as per spec.
>
>

Yes.

-- 
error compiling committee.c: too many arguments to function

