Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946Ab0JSKhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:37:16 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:49314 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0JSKhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:37:15 -0400
Message-ID: <4CBD739A.2010500@collabora.co.uk>
Date: Tue, 19 Oct 2010 11:31:54 +0100
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>
Subject: Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CB1D79A.6070805@redhat.com>
In-Reply-To: <4CB1D79A.6070805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/10 16:11, Avi Kivity wrote:
> On 10/06/2010 05:59 PM, Ian Molton wrote:
>> This patch implements a virtio-based transport for use by a
>> virtualised OpenGL passthrough implementation.
>>
>> The libGL and qemu-gl code to support this patch are available here:
>>
>> http://gitorious.org/vm-gl-accel/qemu-gl
>> http://gitorious.org/vm-gl-accel/qemu-libgl
>>
>>
>> Comments please!
>
> 1. copy qemu-devel

Ok, will do.

> an virtualization@, many virtio developers live there.

you mean virtualization@lists.osdl.org ?

> 2. should start with a patch to the virtio-pci spec to document what
> you're doing

Where can I find that spec?

>> + /* Transfer data */
>> + if (virtqueue_add_buf(vq, sg_list, o_page, i_page, (void *)1)>= 0) {
>> + virtqueue_kick(vq);
>> + /* Chill out until it's done with the buffer. */
>> + while (!virtqueue_get_buf(vq,&count))
>> + cpu_relax();
>> + }
>> +
>
> This is pretty gross, and will burn lots of cpu if the hypervisor
> processes the queue asynchronously.

It doesnt, at present... It could be changed fairly easily ithout 
breaking anything if that happens though.

-Ian


