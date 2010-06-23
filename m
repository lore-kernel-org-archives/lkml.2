Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0FWOFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 10:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367Ab0FWOFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 10:05:40 -0400
Date: Wed, 23 Jun 2010 16:59:47 +0300
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
Message-ID: <20100623135946.GA30526@redhat.com>
References: <20100610152252.GA3510@redhat.com> <4C22132F.4060307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C22132F.4060307@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 04:59:11PM +0300, Avi Kivity wrote:
> On 06/10/2010 06:22 PM, Michael S. Tsirkin wrote:
>> virtio-pci resets the device at startup by writing to the status
>> register, but this does not clear the pci config space,
>> specifically msi enable status which affects register
>> layout.
>>
>> This breaks things like kdump when they try to use e.g. virtio-blk.
>>
>> Fix by forcing msi off at startup. Since pci.c already has
>> a routine to do this, we export and use it instead of duplicating code.
>>
>>    
>
> Why doesn't a device reset result in msi being cleared?

This is not a standard function reset. This is virtio specific
command. So it only clears virtio registers.

> Shouldn't a reset be equivalent to power cycling?

If we did this, driver would need to restore registers
such as BAR etc.

> -- 
> error compiling committee.c: too many arguments to function
