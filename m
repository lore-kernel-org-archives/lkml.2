Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab2GQKOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:14:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab2GQKOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:14:42 -0400
Message-ID: <50053B09.2060703@redhat.com>
Date: Tue, 17 Jul 2012 12:14:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Asias He <asias@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/5] Add vhost-blk support
References: <1342107302-28116-1-git-send-email-asias@redhat.com> <CAJSP0QWgmXns89se+xdGgM6i1_hsfVWPQ8caHua9d-dDA4CTDQ@mail.gmail.com> <50052276.2080906@redhat.com> <500527BA.9000001@redhat.com> <20120717094526.GC7949@redhat.com>
In-Reply-To: <20120717094526.GC7949@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2012 11:45, Michael S. Tsirkin ha scritto:
>> So it begs the question, is it going to be used in production, or just a
>> useful reference tool?
> 
> Sticking to raw already makes virtio-blk faster, doesn't it?
> In that vhost-blk looks to me like just another optimization option.
> Ideally I think user just should not care where do we handle virtio:
> in-kernel or in userspace.  One can imagine it being enabled/disabled
> automatically if none of the features unsupported by it are used.

Ok, that would make more sense.  One difference between vhost-blk and
vhost-net is that for vhost-blk there are also management actions that
would trigger the switch, for example a live snapshot.

So a prerequisite for vhost-blk would be that it is possible to disable
it on the fly while the VM is running, as soon as all in-flight I/O is
completed.

(Note that, however, this is not possible for vhost-scsi, because it
really exposes different hardware to the guest.  It must not happen that
a kernel upgrade or downgrade toggles between userspace SCSI and
vhost-scsi, for example).

>> having to
>> support the API; having to handle transition from one more thing when
>> something better comes out.
> 
> Well this is true for any code. If the limited featureset which
> vhost-blk can accelerate is something many people use, then accelerating
> by 5-15% might outweight support costs.

It is definitely what people use if they are interested in performance.

Paolo
