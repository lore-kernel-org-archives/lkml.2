Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1CPEbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 00:31:10 -0400
Received: from ozlabs.org ([203.10.76.45]:58722 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1CPEbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 00:31:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org
Cc: stefanha@gmail.com, kwolf@redhat.com, prerna@linux.vnet.ibm.com,
        aliguori@us.ibm.com
Subject: Re: [PATCH, RFC] virtio_blk: add cache control support
In-Reply-To: <20110315141644.GA30803@lst.de>
References: <20110315141049.GA30627@lst.de> <20110315141644.GA30803@lst.de>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Wed, 16 Mar 2011 14:39:39 +1030
Message-ID: <87y64fhfjw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 15:16:44 +0100, Christoph Hellwig <hch@lst.de> wrote:
> Add support for the new dynamic features config space field to allow
> en/disabling the write cache at runtime.  The userspace interface is
> a SCSI-compatible sysfs attribute.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hi Christoph,

   Neat work.  Minor comments:

> +	if (strncmp(buf, "write through", sizeof("write through") - 1) == 0) {
> +		;
> +	} else if (strncmp(buf, "write back", sizeof("write back") - 1) == 0) {

   Is there a reason we're not letting gcc and/or strcmp do the
optimization work here?

> +	vdev->config->set(vdev, offsetof(struct virtio_blk_config, features),
> +	                  &features, sizeof(features));
> +
> +	vdev->config->get(vdev, offsetof(struct virtio_blk_config, features),
> +			  &features2, sizeof(features2));
> +
> +	if ((features & VIRTIO_BLK_RT_WCE) !=
> +	    (features2 & VIRTIO_BLK_RT_WCE))
> +		return -EIO;

   This seems like a debugging check you left in.  Or do you suspect
some issues?

Thanks,
Rusty.
