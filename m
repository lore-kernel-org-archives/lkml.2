Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1LAHvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:51:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1LAHvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:51:20 -0500
Message-ID: <4ED74E54.3070303@suse.de>
Date: Thu, 01 Dec 2011 10:52:20 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: virtio-scsi spec (was Re: [PATCH] Add virtio-scsi to the virtio
 spec)
References: <1322661042-28191-1-git-send-email-pbonzini@redhat.com> <1322661042-28191-2-git-send-email-pbonzini@redhat.com> <4ED63AE1.8090105@suse.de> <4ED65BA4.3000003@redhat.com>
In-Reply-To: <4ED65BA4.3000003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2011 05:36 PM, Paolo Bonzini wrote:
> On 11/30/2011 03:17 PM, Hannes Reinecke wrote:
>>> seg_max is the maximum number of segments that can be in a
>>> command. A bidirectional command can include seg_max input
>>> segments and seg_max output segments.
>>>
>> I would like to have the other request_queue limitations exposed
>> here, too.
>> Most notably we're missing the maximum size of an individual segment
>> and the maximum size of the overall I/O request.
>
> The virtio transport does not put any limit, as far as I know.
>
Virtio doesn't, but the underlying device/driver might.
And if we don't expose these values we cannot format the request correctly.

>> As this is the host specification I really would like to see an host
>> identifier somewhere in there.
>> Otherwise we won't be able to reliably identify a virtio SCSI host.
>
> I thought about it, but I couldn't figure out exactly how to use it. If
> it's just allocating 64 bits in the configuration space (with the
> stipulation that they could be zero), let's do it now. Otherwise a
> controlq command is indeed better, and it can come later.
>
> But even if it's just a 64-bit value, then: 1) where would you place it
> in sysfs for userspace? I can make up a random name, but existing user
> tools won't find it and that's against the design of virtio-scsi. 2) How
> would it be encoded as a transport ID? Is it FC, or firewire, or SAS, or
> what?
>
I was thinking of something along the lines of the TransportID as 
defined in SPC.
Main idea is to have a unique ID by which we can identify a given 
virtio-scsi host. Admittedly it might not be useful in general, so it 
might be an idea to delegate this to another controlq command.

>> Plus you can't calculate the ITL nexus information, making
>> Persistent Reservations impossible.
>
> They are not impossible, only some features such as SPEC_I_PT. If you
> use NPIV or iSCSI in the host, then the persistent reservations will
> already get the correct initiator port. If not, much more work is needed.
>
Yes, for a a shared (physical) SCSI host persistent reservations will be 
tricky.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

