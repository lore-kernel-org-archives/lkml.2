Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab1FJOgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:36:04 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:58971 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1FJOgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:36:00 -0400
Date: Fri, 10 Jun 2011 10:35:50 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Message-ID: <1504884387.187692.1307716550265.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4DF21447.6090005@suse.de>
Subject: Re: virtio scsi host draft specification, v3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If requests are placed on arbitrary queues you'll inevitably run on
> locking issues to ensure strict request ordering.
> I would add here:
> 
> If a device uses more than one queue it is the responsibility of the
> device to ensure strict request ordering.

Applied with s/device/guest/g.

> Please do not rely in bus/target/lun here. These are leftovers from
> parallel SCSI and do not have any meaning on modern SCSI
> implementation (eg FC or SAS). Rephrase that to
> 
> The lun field is the Logical Unit Number as defined in SAM.

Ok.

> >      The status byte is written by the device to be the SCSI status
> >      code.
>
> ?? I doubt that exists. Make that:
> 
> The status byte is written by the device to be the status code as
> defined in SAM.

Ok.

> >      The response byte is written by the device to be one of the
> >      following:
> >
> >      - VIRTIO_SCSI_S_OK when the request was completed and the
> >      status byte
> >        is filled with a SCSI status code (not necessarily "GOOD").
> >
> >      - VIRTIO_SCSI_S_UNDERRUN if the content of the CDB requires
> >      transferring
> >        more data than is available in the data buffers.
> >
> >      - VIRTIO_SCSI_S_ABORTED if the request was cancelled due to a
> >      reset
> >        or another task management function.
> >
> >      - VIRTIO_SCSI_S_FAILURE for other host or guest error. In
> >      particular,
> >        if neither dataout nor datain is empty, and the
> >        VIRTIO_SCSI_F_INOUT
> >        feature has not been negotiated, the request will be
> >        immediately
> >        returned with a response equal to VIRTIO_SCSI_S_FAILURE.
> >
> And, of course:
> 
> VIRTIO_SCSI_S_DISCONNECT if the request could not be processed due
> to a communication failure (eg device was removed or could not be
> reached).

Ok.

> This specification implies a strict one-to-one mapping between host
> and target. IE there is no way of specifying more than one target
> per host.

Actually no, the intention is to use hierarchical LUNs to support
more than one target per host.

Paolo
