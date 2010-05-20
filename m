Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0ETGGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab0ETGGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:06:39 -0400
Message-ID: <4BF4D15E.4040908@redhat.com>
Date: Thu, 20 May 2010 09:06:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, Juan Quintela <quintela@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
       amit.shah@redhat.com
Subject: Re: [PATCH] vhost-net: utilize PUBLISH_USED_IDX feature
References: <20100518011931.GA21918@redhat.com> <4BF41A33.8090309@redhat.com> <20100519222718.GB4111@redhat.com>
In-Reply-To: <20100519222718.GB4111@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 01:27 AM, Michael S. Tsirkin wrote:
> On Wed, May 19, 2010 at 08:04:51PM +0300, Avi Kivity wrote:
>    
>> On 05/18/2010 04:19 AM, Michael S. Tsirkin wrote:
>>      
>>> With PUBLISH_USED_IDX, guest tells us which used entries
>>> it has consumed. This can be used to reduce the number
>>> of interrupts: after we write a used entry, if the guest has not yet
>>> consumed the previous entry, or if the guest has already consumed the
>>> new entry, we do not need to interrupt.
>>> This imporves bandwidth by 30% under some workflows.
>>>
>>> Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
>>> ---
>>>
>>> Rusty, Dave, this patch depends on the patch
>>> "virtio: put last seen used index into ring itself"
>>> which is currently destined at Rusty's tree.
>>> Rusty, if you are taking that one for 2.6.35, please
>>> take this one as well.
>>> Dave, any objections?
>>>
>>>        
>> I object: I think the index should have its own cacheline,
>>      
> The issue here is that host/guest do not know each
> other's cache line size. I guess we could just put it
> at offset 128 or something like that ... Rusty?
>    

Not so pretty, but ok.

>    
>> and that it should be documented before merging.
>>      
> I think you meant to object to the virtio patch, not this one.  This
> patch does not introduce new layout, just implements host support.
> virtio spec patch will follow: it is not part of linux tree so
> there is no patch dependency.
>    

There is a reviewer dependency.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

