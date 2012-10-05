Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2JFG3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 02:29:43 -0400
Received: from ozlabs.org ([203.10.76.45]:33691 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab2JFG3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 02:29:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, avi@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 0/3] virtio-net: inline header support
In-Reply-To: <506D8DD5.20904@redhat.com>
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au> <506C192E.5060700@redhat.com> <87bogj2j1b.fsf@rustcorp.com.au> <506D3610.7000103@redhat.com> <87ipaq1jtt.fsf@rustcorp.com.au> <506D8DD5.20904@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 05 Oct 2012 15:13:01 +0930
Message-ID: <87391t1nkq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 04/10/2012 14:51, Rusty Russell ha scritto:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> 
>>> Il 04/10/2012 02:11, Rusty Russell ha scritto:
>>>>>> There's a reason I haven't done this.  I really, really dislike "my
>>>>>> implemention isn't broken" feature bits.  We could have an infinite
>>>>>> number of them, for each bug in each device.
>>>>>
>>>>> However, this bug affects (almost) all implementations and (almost) all
>>>>> devices.  It even makes sense to reserve a transport feature bit for it
>>>>> instead of a device feature bit.
>>>>
>>>> Perhaps, but we have to fix the bugs first!
>>>
>>> Yes. :)  Isn't that what mst's patch does?
>>>
>>>> As I said, my torture patch broke qemu immediately.  Since noone has
>>>> leapt onto fixing that, I'll take a look now...
>>>
>>> I can look at virtio-scsi.
>> 
>> Actually, you can't, see my reply to Anthony...
>> 
>> Message-ID: <87lifm1y1n.fsf@rustcorp.com.au>
>
>     struct virtio_scsi_req_cmd {
>         // Read-only
>         u8 lun[8];
>         u64 id;
>         u8 task_attr;
>         u8 prio;
>         u8 crn;
>         char cdb[cdb_size];
>         char dataout[];
>         // Write-only part
>         u32 sense_len;
>         u32 residual;
>         u16 status_qualifier;
>         u8 status;
>         u8 response;
>         u8 sense[sense_size];
>         char datain[];
>     };
>
> where cdb_size and sense_size come from configuration space.  The device
> right now expects everything before dataout/datain to be in a single
> descriptor, but that's in no way part of the spec.  Am I missing
> something egregious?

Since you wrote it, I hope not :)

That's good.  But virtio_blk's scsi command is insoluble AFAICT.  As I
said to Anthony, the best rules are "always" and "never", so I'd really
rather not have to grandfather that in.

Cheers,
Rusty.
