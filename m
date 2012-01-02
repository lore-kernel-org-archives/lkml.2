Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2ABQSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:18:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab2ABQSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:18:40 -0500
Message-ID: <4F01D8C5.1060300@redhat.com>
Date: Mon, 02 Jan 2012 17:18:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Stefan Hajnoczi <stefanha@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to
 BIO
References: <1324429254-28383-1-git-send-email-minchan@kernel.org> <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com> <20111222234135.GB7056@barrios-laptop.redhat.com> <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com> <4F01D750.7040304@redhat.com> <20120102161518.GA28940@infradead.org>
In-Reply-To: <20120102161518.GA28940@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2012 05:15 PM, Christoph Hellwig wrote:
> >  When QEMU uses O_DIRECT, the guest should not use QUEUE_FLAG_NONROT
> >  unless it is active for the host disk as well.  (In doubt, as is the
> >  case for remote hosts accessed over NFS, I would also avoid NONROT
> >  and allow more coalescing).
>
> Do we have any benchmark numbers where QUEUE_FLAG_NONROT makes a
> difference?

Not that I know of.

> I tried a few times, and the only constant measureable
> thing was that it regressed performance when used for rotating devices
> in a few benchmarks.

Were you trying with cache=none or writeback?  For cache=none, that's 
exactly what I'd expect.  cache=writeback could be more interesting...

Paolo
