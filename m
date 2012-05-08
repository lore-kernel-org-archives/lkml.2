Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2EHGnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 02:43:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2EHGnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 02:43:09 -0400
Message-ID: <4FA8C075.3030101@redhat.com>
Date: Tue, 08 May 2012 08:43:01 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Amit Shah <amit.shah@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC PATCH] virtio_console: link vq to port with a private pointer
 in struct virtqueue
References: <1334756013-11752-1-git-send-email-pbonzini@redhat.com> <87397be80k.fsf@rustcorp.com.au>
In-Reply-To: <87397be80k.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/05/2012 04:11, Rusty Russell ha scritto:
>> > For virtio-scsi multiqueue support I would like to have an easy and
>> > fast way to go from a virtqueue to the internal struct for that
>> > queue.
>> > 
>> > It turns out that virtio-serial has the same need, but it gets
>> > by with a simple list walk.
>> > 
>> > This patch adds a pointer to struct virtqueue that is reserved for
>> > the virtio device, and uses it in virtio-serial.
> I ike the concept, but share Michael's concern with naming confusion.
> 
> How bad would be it to get rid of the current ->priv and use
> container_of() instead?  ie. have virtio_pci, virtio_mmio, lguest_bus
> and s390's kvm_virtio embed the struct virtqueue?

How bad is not the question, it would actually be pretty good... the
question is more how hard! :)

lguest and s390 are a bit different from the others because ->priv
points into a memory-mapped descriptor provided by the host; PCI and
MMIO have lots of similarities.

Looks doable...

Paolo
