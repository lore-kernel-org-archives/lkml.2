Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab2GEGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:46:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab2GEGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:46:14 -0400
Message-ID: <4FF53824.6090303@redhat.com>
Date: Thu, 05 Jul 2012 08:45:56 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <20120704154220.GB27064@redhat.com> <4FF46728.7030302@redhat.com> <20120704160258.GB27271@redhat.com> <4FF46A92.3020009@redhat.com> <20120704213037.GA27713@redhat.com>
In-Reply-To: <20120704213037.GA27713@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 23:30, Michael S. Tsirkin ha scritto:
>>>>>> +static int virtblk_get_cache_mode(struct virtio_device *vdev)
>>>>>
>>>>> Why are you converting u8 to int here?
>>>>
>>>> The fact that it is a u8 is really an internal detail.  Perhaps the bug
>>>> is using u8 in the callers.
>>>
>>> Make it bool then?
>>>
>>> You are using u8 in the config. So you could get any value
>>> besides 0 and 1, and you interpret that as 1.
>>> Is 1 always a safe value? If not maybe it's better to set
>>> to a safe value if it is not 0 or 1, that is we don't know how to interpret it.
>>
>> That would be a host bug; the spec only gives meaning to 0 and 1.
> 
> Yes but if the other side does not validate values implementations
> *will* have bugs. Why not declare bits 1-7 reserved?

Ok, that would be a different change.  I thought about it yesterday, but
it seemed like a useless complication.  It's not like we have been
adding configuration fields every other week. :)

But I can certainly prepare patches to both virtio-blk and the spec for
that if you prefer.

Paolo
