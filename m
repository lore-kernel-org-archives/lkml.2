Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2GYRoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:44:04 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:50558 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2GYRn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:43:58 -0400
Message-ID: <50103043.5050508@redhat.com>
Date: Wed, 25 Jul 2012 19:43:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Wang Sen <senwang@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        JBottomley@parallels.com, stefanha@linux.vnet.ibm.com,
        mc@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: virtio(-scsi) vs. chained sg_lists (was Re: [PATCH] scsi: virtio-scsi:
 Fix address translation failure of HighMem pages used by sg list)
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <500FBAE8.2050107@panasas.com> <500FBF37.50603@redhat.com> <500FE7D2.7070101@panasas.com> <500FEB63.3000709@redhat.com> <500FF412.3090600@panasas.com> <50100014.2010109@redhat.com> <50101091.5090909@panasas.com>
In-Reply-To: <50101091.5090909@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/07/2012 17:28, Boaz Harrosh ha scritto:
>> 1) what I get is a scsi_cmnd which contains an N-element scatterlist.
>>
>> 2) virtio-scsi has to build the "packet" that is passed to the hardware
>> (it does not matter that the hardware is virtual).  This packet (per
>> virtio-scsi spec) has an N+1-element scatterlist, where the first
>> element is a request descriptor (struct virtio_scsi_cmd_req), and the
>> others describe the written data.
> 
> Then "virtio-scsi spec" is crap. It overloads the meaning of
> "struct scatterlist" of the first element in an array. to be a
> "struct virtio_scsi_cmd_req".

What the holy fuck?  The first element simply _points_ to the "struct
virtio_scsi_cmd_req", just like subsequent elements point to the data.

And the protocol of the device is _not_ a struct scatterlist[].  The
virtio _API_ takes that array and converts to a series of physical
address + offset pairs.

> Since you need to change the standard to support chaining then
> it is a good time to fix this.

Perhaps it is a good time for you to read the virtio spec.  You are
making a huge confusion between the LLD->virtio interface and the
virtio->hardware interface.  I'm talking only of the former.

>> 3) virtio takes care of converting the "packet" from a scatterlist
>> (which currently must be a flat one) to the hardware representation.
>> Here a walk is inevitable, so we don't care about this walk.
> 
> "hardware representation" you mean aio or biovec, what ever the
> IO submission path uses at the host end?

No, I mean the way the virtio spec encodes the physical address + offset
pairs.

I stopped reading here.

Paolo
