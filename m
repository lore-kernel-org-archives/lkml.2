Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0JSKjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:39:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758150Ab0JSKje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:39:34 -0400
Message-ID: <4CBD7560.6080207@redhat.com>
Date: Tue, 19 Oct 2010 12:39:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Ian Molton <ian.molton@collabora.co.uk>
CC: linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CB1D79A.6070805@redhat.com> <4CBD739A.2010500@collabora.co.uk>
In-Reply-To: <4CBD739A.2010500@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 12:31 PM, Ian Molton wrote:
>
>> an virtualization@, many virtio developers live there.
>
> you mean virtualization@lists.osdl.org ?

Yes.

>
>> 2. should start with a patch to the virtio-pci spec to document what
>> you're doing
>
> Where can I find that spec?

http://ozlabs.org/~rusty/virtio-spec/

>
>>> + /* Transfer data */
>>> + if (virtqueue_add_buf(vq, sg_list, o_page, i_page, (void *)1)>= 0) {
>>> + virtqueue_kick(vq);
>>> + /* Chill out until it's done with the buffer. */
>>> + while (!virtqueue_get_buf(vq,&count))
>>> + cpu_relax();
>>> + }
>>> +
>>
>> This is pretty gross, and will burn lots of cpu if the hypervisor
>> processes the queue asynchronously.
>
> It doesnt, at present... It could be changed fairly easily ithout 
> breaking anything if that happens though.

The hypervisor and the guest can be changed independently.  The driver 
should be coded so that it doesn't depend on hypervisor implementation 
details.

-- 
error compiling committee.c: too many arguments to function

