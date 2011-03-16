Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab1CPOKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 10:10:04 -0400
Received: from verein.lst.de ([213.95.11.211]:55980 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab1CPOJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 10:09:59 -0400
Date: Wed, 16 Mar 2011 15:09:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org, stefanha@gmail.com, kwolf@redhat.com,
        prerna@linux.vnet.ibm.com, aliguori@us.ibm.com
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
Message-ID: <20110316140958.GB21877@lst.de>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de> <87y64fhfjw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y64fhfjw.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:39:39PM +1030, Rusty Russell wrote:
> > +	if (strncmp(buf, "write through", sizeof("write through") - 1) == 0) {
> > +		;
> > +	} else if (strncmp(buf, "write back", sizeof("write back") - 1) == 0) {
> 
>    Is there a reason we're not letting gcc and/or strcmp do the
> optimization work here?

I'm happ to switch strcmp.

> > +	vdev->config->set(vdev, offsetof(struct virtio_blk_config, features),
> > +	                  &features, sizeof(features));
> > +
> > +	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
> > +			  &features2, sizeof(features2));
> > +
> > +	if ((features & VIRTIO_BLK_RT_WCE) !=
> > +	    (features2 & VIRTIO_BLK_RT_WCE))
> > +		return -EIO;
> 
>    This seems like a debugging check you left in.  Or do you suspect
> some issues?

No, it's intentional.  config space writes can't return errors, so we need
to check that the value has really changed.  I'll add a comment explaining it.

