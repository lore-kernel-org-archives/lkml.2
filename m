Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2DRSiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab2DRSiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:38:07 -0400
Message-ID: <4F8F0A08.8010900@redhat.com>
Date: Wed, 18 Apr 2012 20:38:00 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private pointer
 in struct virtqueue
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com> <20120418142146.GB11801@redhat.com> <4F8ED0E4.6000702@redhat.com> <20120418161028.GB12815@redhat.com>
In-Reply-To: <20120418161028.GB12815@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/04/2012 18:10, Michael S. Tsirkin ha scritto:
> On Wed, Apr 18, 2012 at 04:34:12PM +0200, Paolo Bonzini wrote:
>> Il 18/04/2012 16:21, Michael S. Tsirkin ha scritto:
>>>> @@ -1872,6 +1864,8 @@ static int virtcons_restore(struct virtio_device *vdev)
>>>>  	list_for_each_entry(port, &portdev->ports, list) {
>>>>  		port->in_vq = portdev->in_vqs[port->id];
>>>>  		port->out_vq = portdev->out_vqs[port->id];
>>>> +		port->in_vq->vdev_priv = port;
>>>> +		port->out_vq->vdev_priv = port;
>>>>  
>>>>  		fill_queue(port->in_vq, &port->inbuf_lock);
>>>>  
>>>
>>> Let's add an API to set this pointer.
>>> Document that you must not set it after
>>> probe/restore returned.
>>
>> Why?
> 
> How would you prevent races if you do?

With some lock in the driver.  It's private to the driver, so the driver
decides how to synchronize access.

>>>>   * @priv: a pointer for the virtqueue implementation to use.
>>>>   */
>>>>  struct virtqueue {
>>>> @@ -21,6 +22,7 @@ struct virtqueue {
>>>>  	void (*callback)(struct virtqueue *vq);
>>>>  	const char *name;
>>>>  	struct virtio_device *vdev;
>>>> +	void *vdev_priv;
>>>>  	void *priv;
>>>
>>> The name is confusing: it seems to imply it's a device pointer.
>>
>> ... it's private to the driver that owns vdev, hence the name.
> 
> I own a car but I'm not called Michael Car :)
> driver_priv might be ok too. unfortunately virtio-pci
> is also a driver so it can be misunderstood.

Yes.  Is fixing the comment and keeping the vdev_priv name ok with you?

> devices should dominate. ring is an implementation detail.

Ring came first, ring gets the nice name. :)

Paolo
