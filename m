Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab1HaQyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:54:52 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1HaQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:54:50 -0400
Date: Wed, 31 Aug 2011 19:52:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        alan@linux.intel.com
Subject: Re: [PATCH 05/12] staging: mei: adding watchdog ping
Message-ID: <20110831165224.GF3705@shale.localdomain>
References: <1314798168-15613-1-git-send-email-oren.jer.weil@intel.com>
 <1314798168-15613-6-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314798168-15613-6-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 04:42:41PM +0300, Oren Weil wrote:
> +static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
> +{
> +	int ret = 0;
> +	struct mei_device *dev;
> +	dev = pci_get_drvdata(mei_device);
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	mutex_lock(&dev->device_lock);
> +
> +	if (dev->wd_cl.state != MEI_FILE_CONNECTED) {
> +		dev_dbg(&dev->pdev->dev, "wd is not connected.\n");
> +		ret = -ENODEV;
> +		goto end;
> +	}
> +
> +	/* Check if we can send the ping to HW*/
> +	if (dev->mei_host_buffer_is_empty &&
> +		mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
> +			dev->mei_host_buffer_is_empty = false;
        ^^^^^^^^^^^^^^^^

This is a two tab indent.  Don't do that.

regards,
dan carpenter

> +			dev_dbg(&dev->pdev->dev, "sending watchdog ping\n");
> +
> +			if (mei_wd_send(dev)) {
> +				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
> +				ret = -EIO;
> +				goto end;
> +			}
> +
> +			if (mei_flow_ctrl_reduce(dev, &dev->wd_cl)) {
> +				dev_dbg(&dev->pdev->dev, "mei_flow_ctrl_reduce() failed.\n");
> +				ret = -EIO;
> +				goto end;
> +			}
> +
> +		} else {
> +			dev->wd_pending = true;
> +		}
> +
> +end:
> +	mutex_unlock(&dev->device_lock);
> +	return ret;
> +}


