Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab0HERqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0HERqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:46:46 -0400
Message-ID: <4C5AF8FD.1060506@redhat.com>
Date: Thu, 05 Aug 2010 19:46:37 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Thunderbird/3.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org,
        Daniel Stodden <daniel.stodden@citrix.com>
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
References: <20100804115124.GA1496@infradead.org> <4C596252.9010806@fusionio.com> <20100804164441.GA7838@infradead.org> <4C5AF01C.3040601@goop.org> <20100805171944.GA28446@infradead.org>
In-Reply-To: <20100805171944.GA28446@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/10 19:19, Christoph Hellwig wrote:
> On Thu, Aug 05, 2010 at 10:08:44AM -0700, Jeremy Fitzhardinge wrote:
>>   On 08/04/2010 09:44 AM, Christoph Hellwig wrote:
>>>> But either the blkfront patch is wrong and it needs to be fixed,
>>> Actually both the old and the new one are wrong, but I'd say the new
>>> one is even more wrong.
>>>
>>> _TAG implies that the device can do ordering by tag.  And at least the
>>> qemu xen_disk backend doesn't when it advertizes this feature.
>>
>> We don't use qemu at all for block storage; qemu (afaik) doesn't
>> have a blkback protocol implementation in it.

Upstream qemu has.

>> I'm guessing xen_disk
>> is to allow kvm to be compatible with Xen disk images?

No, is actually is a blkback implementation.

>> It certainly
>> isn't a reference implementation.

Indeed.  I also havn't tested it for ages, not sure whenever it still works.

> Disk images formats have nothing to do with the I/O interface.  I
> believe Gerd added it for running unmodified Xen guests in qemu,
> but he can explain more of it.

Well, you can boot pv kernels with upstream qemu.  qemu must be compiled 
with xen support enabled, you need xen underneath and xenstored must 
run, but nothing else (xend, tapdisk, ...) is required.  qemu will call 
xen libraries to build the domain and run the pv kernel.  qemu provides 
backends for console, framebuffer, network and disk.

There was also the plan to allow xen being emulated, so you could run pv 
kernels in qemu without xen (using tcg or kvm).  Basically xenner merged 
into qemu.  That project was never finished though and I didn't spend 
any time on it for at least one year ...

Hope this clarifies,
   Gerd

