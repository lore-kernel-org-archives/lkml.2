Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2BMH6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:58:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2BMH6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:58:02 -0500
Message-ID: <4F38C27E.7030300@redhat.com>
Date: Mon, 13 Feb 2012 09:57:50 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Hoff <christian.hoff@de.ibm.com>,
        borntrae@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        mst@redhat.com, rusty@rustcorp.com.au
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com> <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com> <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com> <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com> <4F313526.2050907@redhat.com> <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com> <4F3390FB.80107@redhat.com> <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com> <4F38B657.7060405@de.ibm.com>
In-Reply-To: <4F38B657.7060405@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2012 09:05 AM, Christian Borntraeger wrote:
> On 12/02/12 21:16, James Bottomley wrote:
>> Well, no-one's yet answered the question I had about why.
>
> Just to give one example from a different angle:
> In the big datacenters tape libraries are still very important, and lots
> of them have a scsi attachement. virtio-blk certainly is not the right
> way to handle those. Furthermore it seems even pretty hard to craft
> a virtio-tape since most of those libraries have vendor specific library
> controls (via sg). We would need to duplicate scsi generic (hint, hint :-)
>
>> virtio-scsi seems to be a basic duplication of virtio-blk except that it seems to
>> fix some problems virtio-blk has.  Namely queue parameter discover,
>> which virtio-blk doesn't seem to do.  There may also be a reason to cut
>> the stack lower down.  Error handling is most often cited for this, but
>> no-one's satisfactorily explaned why it's better to do error handling in
>> the guest instead of the host.
>>
>> Could someone please explain to me why you can't simply fix virtio-blk?
>
> I dont think that virtio-scsi will replace virtio-blk everywhere. For non-scsi
> block devices, image files or logical volumes virtio-blk seems to be the right
> approach, I think.

+1

virtio-scsi is superior w.r.t:
   - Device support: tapes, cdroms, other
   - Does guest-host mapped multipath
   - Supports plenty of virtual disks mapped to the guest w/o need for a
     pci slot per each virtio-blk
   - offload fancy/new/sophisticated scsi commands from the guest to the
     storage array w/o need for qemu implementation. Example XCOPY.

There are some more goodies like ability to support windows guest 
clustering w/o hacky versions of scsi pass through over virtio-blk.
virtio-blk is also a candidate to change the request based towards bio 
based implementation, so sticking to it does not buy us too much.

>
>> Or would virtio-blk maintainers give a reason why they're unwilling to
>> have it fixed?
>
> I dont consider virtio-blk broken. It just doesnt cover everything.
>
> Christian
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

