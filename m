Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2HKMwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 08:52:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56782 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab2HKMwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 08:52:06 -0400
MIME-Version: 1.0
In-Reply-To: <1344641012.22564.294.camel@haakon2.linux-iscsi.org>
References: <1344641012.22564.294.camel@haakon2.linux-iscsi.org>
Date: Sat, 11 Aug 2012 13:52:04 +0100
Message-ID: <CAJSP0QXX=4etJ_uGYFzXQ0eEE0M+Ude7ha0aH5SaX1oEUvQoLA@mail.gmail.com>
Subject: Re: virtio-scsi <-> vhost multi lun/adapter performance results with 3.6-rc0
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Christoph Hellwig <hch@lst.de>, hare@suse.de,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 12:23 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Using a KVM guest with 32x vCPUs and 4G memory, the results for 4x
> random I/O now look like:
>
> workload         | jobs | 25% write / 75% read | 75% write / 25% read
> -----------------|------|----------------------|---------------------
> 1x rd_mcp LUN    |   8  |     ~155K IOPs       |      ~145K IOPs
> 16x rd_mcp LUNs  |  16  |     ~315K IOPs       |      ~305K IOPs
> 32x rd_mcp LUNs  |  16  |     ~425K IOPs       |      ~410K IOPs
>
> The full fio randrw results for the six test cases are attached below.
> Also, using a workload of fio numjobs > 16 currently makes performance
> start to fall off pretty sharply regardless of the number of vCPUs..
>
> So running a similar workload with loopback SCSI ports on bare-metal
> produces ~1M random IOPs with 12x LUNs + numjobs=32.  At numjobs=16 here
> with vhost the 16x LUN configuration ends up being in the range of ~310K
> IOPs for the current sweet spot..

This makes me wonder what a comparison against baremetal looks like
and the perf top, mpstat, and kvm_stat results on the host.

Stefan
