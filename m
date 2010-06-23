Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab0FWOtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0FWOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:49:17 -0400
Date: Wed, 23 Jun 2010 17:43:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>, linux-pci@vger.kernel.org,
       Matt Carlson <mcarlson@broadcom.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH for-2.6.35] virtio-pci: disable msi at startup
Message-ID: <20100623144307.GB30526@redhat.com>
References: <20100610152252.GA3510@redhat.com> <4C22132F.4060307@redhat.com> <20100623135946.GA30526@redhat.com> <4C221871.6020509@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C221871.6020509@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 05:21:37PM +0300, Avi Kivity wrote:
> On 06/23/2010 04:59 PM, Michael S. Tsirkin wrote:
>>
>>> Why doesn't a device reset result in msi being cleared?
>>>      
>> This is not a standard function reset. This is virtio specific
>> command. So it only clears virtio registers.
>>    
>
> I see.  We should implement FLR in qemu.

We can do this. Or PM reset. however ...

>  If we don't already do so, we  
> should probably FLR anything that moves when a kexec kernel starts.

Probably only whatever we want to use. But whether this will make it
more, or less robust, is an open question.

>>> Shouldn't a reset be equivalent to power cycling?
>>>      
>> If we did this, driver would need to restore registers
>> such as BAR etc.
>>    
>
> We could save/restore the registers we care about.

It seems easier to clear registers we care about.  It's also too late
now: changing behaviour will break old drivers.

> -- 
> error compiling committee.c: too many arguments to function
