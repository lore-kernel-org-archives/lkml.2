Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018Ab2GYMJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:09:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932911Ab2GYMJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:09:23 -0400
Message-ID: <500FE1F0.3000303@suse.de>
Date: Wed, 25 Jul 2012 14:09:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com>    <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com>    <50044D56.6000400@redhat.com>   <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com>   <50052390.7030908@redhat.com>  <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com>  <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 11:11 AM, James Bottomley wrote:
> On Tue, 2012-07-17 at 10:54 +0200, Paolo Bonzini wrote:
>> Il 17/07/2012 10:40, James Bottomley ha scritto:
>>>>>
>>>>> It's not specific to virtio-scsi, in fact I expect that virtio-scsi will
>>>>> be almost always used with non-removable disks.
>>>>>
>>>>> However, QEMU's SCSI target is not used just for virtio-scsi (for
>>>>> example it can be used for USB storage), and it lets you mark a disk as
>>>>> removable---why? because there exists real hardware that presents itself
>>>>> as an SBC removable disk.  The only thing that is specific to
>>>>> virtualization, is support for online resizing (which generates a unit
>>>>> attention condition CAPACITY DATA HAS CHANGED).
>>> So what's the problem?  If you're doing pass through of a physical disk,
>>> we pick up removable from its inquiry string ... a physical removable
>>> device doesn't get resized.  If you have a virtual disk you want to
>>> resize, you don't set the removable flag in the inquiry data.
>>
>> In practice people will do what you said, and it's not a problem.
>>
>> However, there's nothing that prevents you from running qemu with a
>> removable SCSI disk, and then resizing it.  I would like this to work,
>> because SBC allows it and there's no reason why it shouldn't.
> 
> There's no such thing in the market today as a removable disk that's
> resizeable.  Removable disks are for things like backup cartridges and
> ageing jazz drives.  Worse: most removeable devices today are USB card
> readers whose standards compliance varies from iffy to non existent.
> Resizeable disks are currently the province of storage arrays.
> 
Ho-hum. I beg to disagree.

drivers/scsi/aacraid/aachba.c:2266

		/* Do not cache partition table for arrays */
		scsicmd->device->removable = 1;

To the extend of my knowledge aacraid does this _precisely_ to allow
for resizing; in effect every open() will trigger a device revalidation.

So I guess by just setting the 'removable' flag you should be okay.
You might need to remount it, but that's another story.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)


