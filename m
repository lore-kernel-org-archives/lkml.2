Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2G3Hba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:31:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab2G3Hb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 03:31:28 -0400
Message-ID: <5016383A.5090008@redhat.com>
Date: Mon, 30 Jul 2012 09:31:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Asias He <asias@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Minchan Kim <minchan.kim@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH V3 3/3] virtio-blk: Add bio-based IO path for virtio-blk
References: <971756309.4742543.1343457753475.JavaMail.root@redhat.com> <501610E0.8000504@redhat.com>
In-Reply-To: <501610E0.8000504@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/07/2012 06:43, Asias He ha scritto:
>>
> 
> Yes. Something like this:
> 
>   qemu -drive file=foo.img,cache=writeback/unsafe
> 
> is not safe against power losses also?

cache=writeback and cache=none are safe, cache=unsafe isn't.

> I think we can add REQ_FLUSH & REQ_FUA support to bio path and that
> deserves another patch.

You only need to add REQ_FLUSH support.  The virtio-blk protocol does
not support REQ_FUA, because there's no easy way to do it in userspace.

Paolo
