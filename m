Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2JIH1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2JIH1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:27:32 -0400
Message-ID: <5073D1D8.3060905@redhat.com>
Date: Tue, 09 Oct 2012 09:27:20 +0200
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
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au> <506C192E.5060700@redhat.com> <87bogj2j1b.fsf@rustcorp.com.au> <506D3610.7000103@redhat.com> <87ipaq1jtt.fsf@rustcorp.com.au> <506D8DD5.20904@redhat.com> <87391t1nkq.fsf__40391.6521034718$1349505001$gmane$org@rustcorp.com.au> <507029EB.2050405@redhat.com> <878vbg8cma.fsf@rustcorp.com.au>
In-Reply-To: <878vbg8cma.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/10/2012 06:59, Rusty Russell ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> Il 05/10/2012 07:43, Rusty Russell ha scritto:
>>> That's good.  But virtio_blk's scsi command is insoluble AFAICT.  As I
>>> said to Anthony, the best rules are "always" and "never", so I'd really
>>> rather not have to grandfather that in.
>>
>> It is, but we can add a rule that if the (transport) flag
>> VIRTIO_RING_F_ANY_HEADER_SG is set, the cdb field is always 32 bytes in
>> virtio-blk.
> 
> Could we do that?  It's the cmd length I'm concerned about; is it always
> 32 in practice for some reason?

It is always 32 or less except in very obscure cases that are pretty
much confined to iSCSI.  We don't care about the obscure cases, and the
extra bytes don't hurt.

BTW, 32 is the default cdb_size used by virtio-scsi.

> Currently qemu does:
> 
>     struct sg_io_hdr hdr;
>     memset(&hdr, 0, sizeof(struct sg_io_hdr));
>     hdr.interface_id = 'S';
>     hdr.cmd_len = req->elem.out_sg[1].iov_len;
>     hdr.cmdp = req->elem.out_sg[1].iov_base;
>     hdr.dxfer_len = 0;
> 
> If it's a command which expects more output data, there's no way to
> guess where the boundary is between that command and the data.

Yep, so I understood the problem right.

Paolo
