Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1F2IqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:46:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1F2IqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:46:17 -0400
Date: Wed, 29 Jun 2011 11:46:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
Message-ID: <20110629084619.GB14627@redhat.com>
References: <4DEE2B15.4090809@redhat.com>
 <4DF21447.6090005@suse.de>
 <20110612075140.GB11941@redhat.com>
 <4E0AE0FE.2090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0AE0FE.2090905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 10:23:26AM +0200, Paolo Bonzini wrote:
> On 06/12/2011 09:51 AM, Michael S. Tsirkin wrote:
> >>>
> >>>  If a device uses more than one queue it is the responsibility of the
> >>>  device to ensure strict request ordering.
> >Maybe I misunderstand - how can this be the responsibility of
> >the device if the device does not get the information about
> >the original ordering of the requests?
> >
> >For example, if the driver is crazy enough to put
> >all write requests on one queue and all barriers
> >on another one, how is the device supposed to ensure
> >ordering?
> 
> I agree here, in fact I misread Hannes's comment as "if a driver
> uses more than one queue it is responsibility of the driver to
> ensure strict request ordering".  If you send requests to different
> queues, you know that those requests are independent.  I don't think
> anything else is feasible in the virtio framework.
> 
> Paolo

Like this then?

  If a driver uses more than one queue it is the responsibility of the
  driver to ensure strict request ordering: the device does not
  supply any guarantees about the ordering of requests between different
  virtqueues.


