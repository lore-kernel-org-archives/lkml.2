Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2LUCWC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:22:02 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46624 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUCV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:21:56 -0500
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 21:21:56 EST
Date: Fri, 21 Dec 2012 04:21:50 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>
Subject: Re: [RFCv2 11/11] remoteproc: Support virtio config space.
Message-ID: <20121221022150.GH28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-12-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-12-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:07:00PM +0100, Sjur Brændeland wrote:
> Support virtio configuration space and device status and
> feature negotiation with remote device. This virtio device
> can now access the resource table in shared memory.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---

...

> +void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
> +							void *buf, unsigned len)
> +{
> +	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> +	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
> +	memcpy(buf, cfg + offset, len);
> +}
> +
> +void rproc_virtio_set(struct virtio_device *vdev, unsigned offset,
> +		      const void *buf, unsigned len)
> +{
> +	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
> +	void *cfg = &rvdev->rsc->vring[rvdev->rsc->num_of_vrings];
> +	memcpy(cfg + offset, buf, len);
>  }

Perhaps verify the offset and length to avoid overwriting memory?

Thanks,
Ido.
