Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1F2KAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:00:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51141
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463Ab1F2KA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:00:27 -0400
Date: Wed, 29 Jun 2011 06:00:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
Message-ID: <20110629100018.GA22900@infradead.org>
References: <4DEE2B15.4090809@redhat.com>
 <4DF21447.6090005@suse.de>
 <20110612075140.GB11941@redhat.com>
 <4DF77E90.4080409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF77E90.4080409@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 05:30:24PM +0200, Hannes Reinecke wrote:
> Which is exactly the problem I was referring to.
> When using more than one channel the request ordering
> _as seen by the initiator_ has to be preserved.
> 
> This is quite hard to do from a device's perspective;
> it might be able to process the requests _in the order_ they've
> arrived, but it won't be able to figure out the latency of each
> request, ie how it'll take the request to be delivered to the
> initiator.
> 
> What we need to do here is to ensure that virtio will deliver
> the requests in-order across all virtqueues. Not sure whether it
> does this already.

This only matters for ordered tags, or implicit or explicit HEAD OF
QUEUE tags.  For everything else there's no ordering requirement.
Given that ordered tags don't matter in practice and we don't have
to support them this just leaves HEAD OF QUEUE.  I suspect the
HEAD OF QUEUE semantics need to be implemented using underlying
draining of all queues, which should be okay given that it's
usually used in slow path commands.

