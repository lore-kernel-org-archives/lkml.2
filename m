Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab1D0PSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:18:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:45205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab1D0PSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:18:00 -0400
Date: Wed, 27 Apr 2011 08:18:33 -0700
From: Greg KH <gregkh@suse.de>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se
Subject: Re: [PATCH 3/8] staging/mei: MEI "Link" layer code - MEI Hardware
 communications.
Message-ID: <20110427151833.GF24596@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-4-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303900057-21694-4-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:27:32PM +0300, Oren Weil wrote:
> +/**
> + * mei_flow_ctrl_creds - checks flow_control credentials.
> + *
> + * @dev: the device structure
> + * @file_ext: private data of the file object
> + *
> + * returns 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
> + */
> +int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *file_ext)
> +{
> +	int i;
> +
> +	if (!dev->num_mei_me_clients)
> +		return 0;
> +
> +	if (file_ext == NULL)
> +		return 0;
> +
> +	if (file_ext->mei_flow_ctrl_creds > 0)
> +		return 1;
> +
> +	for (i = 0; i < dev->num_mei_me_clients; i++) {
> +		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
> +			if (dev->me_clients[i].mei_flow_ctrl_creds > 0) {
> +				BUG_ON(dev->me_clients[i].props.single_recv_buf
> +					 == 0);
> +				return 1;
> +			}
> +			return 0;
> +		}
> +	}
> +	BUG();
> +	return 0;

What?

You just crashed your device with no chance of recovery.  NEVER put a
BUG() or BUG_ON() call in a driver, that is just rude in irresponsible.

Especially with a return 0; after it, that's just trying to outsmart the
compiler warning, which is extra foolish.

This happens in other places in this code as well, please fix.

greg k-h
