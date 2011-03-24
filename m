Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1CXAXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:23:32 -0400
Received: from ozlabs.org ([203.10.76.45]:32959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab1CXAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:23:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>, kwolf@redhat.com, aliguori@us.ibm.com,
        stefanha@gmail.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Christian Borntraeger <borntraeger@de.ibm.com>,
        prerna@linux.vnet.ibm.com, Alex Williamson <alex.williamson@hp.com>
Subject: Re: [Qemu-devel] Re: [PATCH, RFC] virtio_blk: add cache control support
In-Reply-To: <20110317142122.GA27717@lst.de>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au> <20110317142122.GA27717@lst.de>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 24 Mar 2011 10:41:51 +1030
Message-ID: <87wrjpbcmw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 15:21:22 +0100, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Mar 17, 2011 at 03:36:08PM +1030, Rusty Russell wrote:
> > OK, under what circumstances could it fail?
> > 
> > If you're using this mechanism to indicate that the host doesn't support
> > the feature, that's making an assumption about the nature of config
> > space writes which isn't true for non-PCI virtio.
> > 
> > ie. lguest and S/390 don't trap writes to config space.
> > 
> > Or perhaps they should?  But we should be explicit about needing it...
> 
> We have the features flag to indicate if updating the caching mode is
> supported, but we we could still fail it for other reasons - e.g. we could fail
> to reopen the file with/without O_SYNC.

OK, then I think you need to make it a real command and feed it into the
request queue.

The theory behind config space is that it's for advertising, not for
interaction.  And it's not ever very good at that...

>  But if lguest or S/390 don't support
> trapping config space write this feature won't work for them at all.  As do
> other features that make use of config space write, e.g. updating the MAC
> address for virtio-net.

Yes, and that was a mistake.  What does qemu do with a partially-written
MAC address?  Lguest ignores it, what does S/390 do?

Alex?

Cheers,
Rusty.
