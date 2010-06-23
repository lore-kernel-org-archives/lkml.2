Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0FWPRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:17:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab0FWPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:17:03 -0400
Message-ID: <4C222508.2060804@redhat.com>
Date: Wed, 23 Jun 2010 18:15:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>, linux-pci@vger.kernel.org,
       Matt Carlson <mcarlson@broadcom.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH for-2.6.35] virtio-pci: disable msi at startup
References: <20100610152252.GA3510@redhat.com> <4C22132F.4060307@redhat.com> <20100623135946.GA30526@redhat.com> <4C221871.6020509@redhat.com> <20100623144307.GB30526@redhat.com>
In-Reply-To: <20100623144307.GB30526@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 05:43 PM, Michael S. Tsirkin wrote:
>
>
>>   If we don't already do so, we
>> should probably FLR anything that moves when a kexec kernel starts.
>>      
> Probably only whatever we want to use. But whether this will make it
> more, or less robust, is an open question.
>    

I'm thinking of a sound card left on (maybe not something you have in 
kdump scenarios) or an industrial controller.  Those cards have side 
effects and you want to quiesce them even if you don't know what they are.

>    
>>>> Shouldn't a reset be equivalent to power cycling?
>>>>
>>>>          
>>> If we did this, driver would need to restore registers
>>> such as BAR etc.
>>>
>>>        
>> We could save/restore the registers we care about.
>>      
> It seems easier to clear registers we care about.

We know the registers we care about, we don't know the ones we don't.  
I'm talking about FLRing all cards, not just those you want to use.

>    It's also too late
> now: changing behaviour will break old drivers.
>    

Why?  the FLR is triggered by the guest kernel, so all drivers will be 
aware it was FLRed.

-- 
error compiling committee.c: too many arguments to function

