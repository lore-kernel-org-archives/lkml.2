Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0IPNOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 09:14:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab0IPNOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 09:14:15 -0400
Message-ID: <4C921823.5080602@redhat.com>
Date: Thu, 16 Sep 2010 15:14:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: enable irq injection from interrupt context
References: <20100916095310.GG20864@redhat.com> <20100916101332.GW3008@redhat.com> <20100916101339.GK20864@redhat.com> <20100916102047.GY3008@redhat.com> <20100916104455.GA22254@redhat.com> <20100916105403.GZ3008@redhat.com> <20100916105352.GB22254@redhat.com> <20100916111752.GA3008@redhat.com> <20100916121338.GA23779@redhat.com> <20100916123301.GE3008@redhat.com> <20100916125717.GA24284@redhat.com>
In-Reply-To: <20100916125717.GA24284@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/16/2010 02:57 PM, Michael S. Tsirkin wrote:
> >
> >  >  >  If you want to split parts that asserts irq and de-asserts it then we
> >  >  >  should have irqfd that tracks line status and knows interrupt line
> >  >  >  polarity.
> >  >
> >  >  Yes, it can know about polarity even though I think it's cleaner to do this
> >  >  per gsi. But it can not track line status as line is shared with
> >  >  other devices.
> >  It should track only device's line status.
>
> There is no such thing as device's line status on real hardware, either.
> Devices do not drive INT# high: they drive it low (all the time)
> or do not drive it at all.
>

That's just an implementation detail.  Devices either assert INT# or 
they do not.  Tying the wires together constitutes an AND gate.  This 
gate has to be modelled somewhere, currently it's in qemu's pci emulation.

-- 
error compiling committee.c: too many arguments to function

