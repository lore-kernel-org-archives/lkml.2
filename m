Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1CQOVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 10:21:25 -0400
Received: from verein.lst.de ([213.95.11.211]:34580 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab1CQOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 10:21:23 -0400
Date: Thu, 17 Mar 2011 15:21:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>, kwolf@redhat.com, aliguori@us.ibm.com,
        stefanha@gmail.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Christian Borntraeger <borntraeger@de.ibm.com>,
        prerna@linux.vnet.ibm.com
Subject: Re: [Qemu-devel] Re: [PATCH, RFC] virtio_blk: add cache control
	support
Message-ID: <20110317142122.GA27717@lst.de>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au> <20110316140958.GB21877@lst.de> <877hbygwu7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hbygwu7.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 03:36:08PM +1030, Rusty Russell wrote:
> > I'm happ to switch strcmp.
> 
> Of course, that's assuming buf is nul terminated.

It's the string the user writes into it, which normally should be
nul-terminated.

> > No, it's intentional.  config space writes can't return errors, so we need
> > to check that the value has really changed.  I'll add a comment explaining it.
> 
> OK, under what circumstances could it fail?
> 
> If you're using this mechanism to indicate that the host doesn't support
> the feature, that's making an assumption about the nature of config
> space writes which isn't true for non-PCI virtio.
> 
> ie. lguest and S/390 don't trap writes to config space.
> 
> Or perhaps they should?  But we should be explicit about needing it...

We have the features flag to indicate if updating the caching mode is
supported, but we we could still fail it for other reasons - e.g. we could fail
to reopen the file with/without O_SYNC.  But if lguest or S/390 don't support
trapping config space write this feature won't work for them at all.  As do
other features that make use of config space write, e.g. updating the MAC
address for virtio-net.

