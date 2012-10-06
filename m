Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2JFMyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 08:54:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43765 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab2JFMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 08:54:08 -0400
Message-ID: <507029EB.2050405@redhat.com>
Date: Sat, 06 Oct 2012 14:54:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, avi@redhat.com
Subject: Re: [PATCH 0/3] virtio-net: inline header support
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au> <506C192E.5060700@redhat.com> <87bogj2j1b.fsf@rustcorp.com.au> <506D3610.7000103@redhat.com> <87ipaq1jtt.fsf@rustcorp.com.au> <506D8DD5.20904@redhat.com> <87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au>
In-Reply-To: <87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/10/2012 07:43, Rusty Russell ha scritto:
>> >     struct virtio_scsi_req_cmd {
>> >         // Read-only
>> >         u8 lun[8];
>> >         u64 id;
>> >         u8 task_attr;
>> >         u8 prio;
>> >         u8 crn;
>> >         char cdb[cdb_size];
>> >         char dataout[];
>> >         // Write-only part
>> >         u32 sense_len;
>> >         u32 residual;
>> >         u16 status_qualifier;
>> >         u8 status;
>> >         u8 response;
>> >         u8 sense[sense_size];
>> >         char datain[];
>> >     };
>> >
>> > where cdb_size and sense_size come from configuration space.  The device
>> > right now expects everything before dataout/datain to be in a single
>> > descriptor, but that's in no way part of the spec.  Am I missing
>> > something egregious?
> Since you wrote it, I hope not :)

Yeah, I guess the confusion came from cdb_size and sense_size being in
configuration space.

> That's good.  But virtio_blk's scsi command is insoluble AFAICT.  As I
> said to Anthony, the best rules are "always" and "never", so I'd really
> rather not have to grandfather that in.

It is, but we can add a rule that if the (transport) flag
VIRTIO_RING_F_ANY_HEADER_SG is set, the cdb field is always 32 bytes in
virtio-blk.

Paolo
