Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab1GLAwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:52:37 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35746 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755054Ab1GLAwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:52:36 -0400
Date: Mon, 11 Jul 2011 20:52:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Mike Snitzer <snitzer@redhat.com>
cc: Roland Dreier <roland@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        <linux-scsi@vger.kernel.org>, Steffen Maier <maier@linux.vnet.ibm.com>,
        "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>,
        Tarak Reddy <tarak.reddy@in.ibm.com>,
        "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: Check that queue is alive in blk_insert_cloned_request()
In-Reply-To: <CAMM=eLfzKuw-2vbERV6D7dAHb1BWopOKZ=dB7vWxcxSCoj6Tkw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107112050480.17690-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, Mike Snitzer wrote:

> [cc'ing dm-devel, vivek and tejun]
> 
> On Fri, Jul 8, 2011 at 7:04 PM, Roland Dreier <roland@kernel.org> wrote:
> > From: Roland Dreier <roland@purestorage.com>
> >
> > This fixes crashes such as the below that I see when the storage
> > underlying a dm-multipath device is hot-removed.  The problem is that
> > dm requeues a request to a device whose block queue has already been
> > cleaned up, and blk_insert_cloned_request() doesn't check if the queue
> > is alive, but rather goes ahead and tries to queue the request.  This
> > ends up dereferencing the elevator that was already freed in
> > blk_cleanup_queue().
> 
> Your patch looks fine to me:
> Acked-by: Mike Snitzer <snitzer@redhat.com>

There's still the issue that Stefan Richter pointed out: The test for a 
dead queue must be made _after_ acquiring the queue lock, not _before_.

Alan Stern

