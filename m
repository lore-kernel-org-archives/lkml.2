Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1HRS7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1HRS7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:47 -0400
Message-ID: <4E4D610D.9010701@redhat.com>
Date: Thu, 18 Aug 2011 20:59:25 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        achender@linux.vnet.ibm.com, Jens Axboe <jaxboe@fusionio.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] loop: add discard support for loop devices
References: <1313063143-14473-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1108171511070.3699@dhcp-27-109.brq.redhat.com> <x497h6aspj1.fsf@segfault.boston.devel.redhat.com> <alpine.LFD.2.00.1108181743440.3957@dhcp-27-109.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1108181743440.3957@dhcp-27-109.brq.redhat.com>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 05:49 PM, Lukas Czerner wrote:
> On Thu, 18 Aug 2011, Jeff Moyer wrote:
>> Seems you missed the bizarre case of configuring a loop device over top
>> of a block device.
> 
> Wow, that is a bizarre case I did not think about at all. But since it
> is so bizarre, do we even care ? The thing is that the only case where
> it would make a difference is if the loop device is put on top of block
> device which actually supports discard.
> 
> In order to fix that I would need to dig out the actual limits for that
> device and set that appropriately for the loop device. Is that worth it
> ? It is not like someone will ever do that (or should) :).

It is bizarre (and being device-mapper developer I surely know better way :-)
but people are still using that.

Historically one of the use of underlying block device was cryptoloop, but here
I think it should be completely deprecated (cryptsetup can handle all old loop
modes as well and default modes for cryptoloop are not safe).
[Can we finally remove crypto loop option it from kernel? ... ok, just tried:)]

There is also out of tree loop-aes based on heavily patched loop device
which usually uses block device underneath
(cryptsetup already can handle all loop-aes modes as well).

Sometimes it is used with --offset parameter for some reason
(like linear device-mapper mapping).

So I do not care if you do not support discard here but please do not break
support for block device mapped through loop.

Thanks,
Milan
