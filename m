Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341Ab2GDEHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:07:13 -0400
Received: from ozlabs.org ([203.10.76.45]:47398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2GDEHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:07:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, dlaor@redhat.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <4FF23F4B.2040803@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>  <1340002390-3950-4-git-send-email-asias@redhat.com>  <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>  <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com> <87r4svxcjw.fsf@rustcorp.com.au> <4FF10B31.60609@redhat.com> <8762a6y89v.fsf@rustcorp.com.au> <4FF23F4B.2040803@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jul 2012 12:10:42 +0930
Message-ID: <87lij0w8np.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2012 08:39:39 +0800, Asias He <asias@redhat.com> wrote:
> On 07/02/2012 02:41 PM, Rusty Russell wrote:
> > Sure, our guest merging might save us 100x as many exits as no merging.
> > But since we're not doing many requests, does it matter?
> 
> We can still have many requests with slow devices. The number of 
> requests depends on the workload in guest. E.g. 512 IO threads in guest 
> keeping doing IO.

You can have many requests outstanding.  But if the device is slow, the
rate of requests being serviced must be low.

Am I misunderstanding something?  I thought if you could have a high
rate of requests, it's not a slow device.

Cheers,
Rusty.
