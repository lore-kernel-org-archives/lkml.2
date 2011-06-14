Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1FNPac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 11:30:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45124 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1FNPaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 11:30:30 -0400
Message-ID: <4DF77E90.4080409@suse.de>
Date: Tue, 14 Jun 2011 17:30:24 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
References: <4DEE2B15.4090809@redhat.com> <4DF21447.6090005@suse.de> <20110612075140.GB11941@redhat.com>
In-Reply-To: <20110612075140.GB11941@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2011 09:51 AM, Michael S. Tsirkin wrote:
> On Fri, Jun 10, 2011 at 02:55:35PM +0200, Hannes Reinecke wrote:
>>> Device operation: request queues
>>> --------------------------------
>>>
>>> The driver queues requests to an arbitrary request queue, and they are
>>> used by the device on that same queue.
>>>
>> What about request ordering?
>> If requests are placed on arbitrary queues you'll inevitably run on
>> locking issues to ensure strict request ordering.
>> I would add here:
>>
>> If a device uses more than one queue it is the responsibility of the
>> device to ensure strict request ordering.
>
> Maybe I misunderstand - how can this be the responsibility of
> the device if the device does not get the information about
> the original ordering of the requests?
>
> For example, if the driver is crazy enough to put
> all write requests on one queue and all barriers
> on another one, how is the device supposed to ensure
> ordering?
>
Which is exactly the problem I was referring to.
When using more than one channel the request ordering
_as seen by the initiator_ has to be preserved.

This is quite hard to do from a device's perspective;
it might be able to process the requests _in the order_ they've 
arrived, but it won't be able to figure out the latency of each 
request, ie how it'll take the request to be delivered to the initiator.

What we need to do here is to ensure that virtio will deliver
the requests in-order across all virtqueues. Not sure whether it 
does this already.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
