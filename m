Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab2DXMbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:31:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab2DXMbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:31:16 -0400
Date: Tue, 24 Apr 2012 14:31:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] hid: Scan the device for group info before adding
 it
In-Reply-To: <1335175627-2270-3-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1204241430190.1856@pobox.suse.cz>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se> <1335175627-2270-3-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Henrik Rydberg wrote:

> In order to allow the report descriptor to influence the hid device
> properties, one needs to parse the descriptor early, without reference
> to any driver. Scan the descriptor for group information during device
> add, before the device has been broadcast to userland. The device
> modalias will contain group information which can be used to
> differentiate between modules. For starters, just handle the generic
> group.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-core.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hid.h    |    5 ++++
>  2 files changed, 67 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index cfcb69e..f932cd5 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -658,6 +658,58 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
>  	return NULL;
>  }
>  
> +static void hid_scan_usage(struct hid_device *hid, u32 usage)
> +{
> +}
> +
> +/*
> + * Scan a report descriptor before the device is added to the bus.
> + * Sets device groups and other properties that determine what driver
> + * to load.
> + */
> +static int hid_scan_report(struct hid_device *hid)
> +{
> +	unsigned int page = 0, delim = 0;
> +	__u8 *start = hid->dev_rdesc;
> +	__u8 *end = start + hid->dev_rsize;

Where do these dev_rdesc and dev_rsize come from? Your patchset doesn't 
seem to be changing the corresponding struct device members (which are 
rdesc and rsize currently), right?

-- 
Jiri Kosina
SUSE Labs
