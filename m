Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab1FLHvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 03:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897Ab1FLHvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 03:51:52 -0400
Date: Sun, 12 Jun 2011 10:51:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
Message-ID: <20110612075140.GB11941@redhat.com>
References: <4DEE2B15.4090809@redhat.com>
 <4DF21447.6090005@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF21447.6090005@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 02:55:35PM +0200, Hannes Reinecke wrote:
> >Device operation: request queues
> >--------------------------------
> >
> >The driver queues requests to an arbitrary request queue, and they are
> >used by the device on that same queue.
> >
> What about request ordering?
> If requests are placed on arbitrary queues you'll inevitably run on
> locking issues to ensure strict request ordering.
> I would add here:
> 
> If a device uses more than one queue it is the responsibility of the
> device to ensure strict request ordering.

Maybe I misunderstand - how can this be the responsibility of
the device if the device does not get the information about
the original ordering of the requests?

For example, if the driver is crazy enough to put
all write requests on one queue and all barriers
on another one, how is the device supposed to ensure
ordering?

-- 
MST
