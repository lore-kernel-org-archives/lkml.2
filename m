Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1GEQIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:08:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53256 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691Ab1GEQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:08:34 -0400
X-Sasl-enc: 8Lk5aGxoW6Ck8/T46xt/8EtocQu9H93n4zxsqwthCZm0 1309882113
Date: Tue, 5 Jul 2011 09:01:32 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 07/77] Staging: hv: vmbus: Introduce a function to map
 the dev_type guid to a name
Message-ID: <20110705160132.GA7214@kroah.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-7-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308255470-3826-7-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:16:40PM -0700, K. Y. Srinivasan wrote:
> In preparation for introducing machinery to support autoloading vmbus 
> drivers, introduce a function to map the dev_type guid to a human readable name.

"Human readable"?

<snip>

> +static const char *blk_dev_type = "hv_block";
> +static const char *net_dev_type = "hv_net";
> +static const char *scsi_dev_type = "hv_scsi";
> +static const char *mouse_dev_type = "hv_mouse";
> +static const char *util_dev_type = "hv_util";

It looks like these are the module names, which aren't the most "human
readable" around.

> +/*
> + * Map the dev_type guid to a human readable string for setting
> + * up module aliases. The indices used in this function are based on
> + * the table defined earlier - supported_device_classes[]
> + */
> +const char *hv_get_devtype_name(const struct hv_guid *type)
> +{
> +	int i;
> +
> +	for (i = 0; i < MAX_NUM_DEVICE_CLASSES_SUPPORTED; i++) {
> +		if (!memcmp(type, supported_device_classes[i].data,
> +				sizeof(struct hv_guid))) {
> +			switch (i) {
> +			case 0:
> +				return scsi_dev_type;
> +			case 1:
> +				return net_dev_type;
> +			case 2:
> +				return mouse_dev_type;
> +			case 3:
> +				return blk_dev_type;
> +			}
> +		}
> +	}
> +	/*
> +	 * Currently the util driver is used
> +	 * to handle all these devices.
> +	 */
> +	return util_dev_type;
> +}

Ok, you create a function to return a string, but I'm really afraid of
what you are going to do in the next patch with this...

