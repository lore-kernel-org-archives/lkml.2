Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0KHLVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 06:21:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:50574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0KHLVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 06:21:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,313,1286175600"; 
   d="scan'208";a="675315190"
Date: Mon, 8 Nov 2010 06:21:31 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Message-ID: <20101108112131.GG4173@linux.intel.com>
References: <628096.54960.qm@web31807.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <628096.54960.qm@web31807.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 01:22:22PM -0700, Luben Tuikov wrote:
> "Be conservative in what you send, liberal in what
> you accept." -- In the spirit of this adage, don't
> send Command IUs with randomly filled in data in
> the reserved fields. (Yes, this shows up on the
> wire.)

Applied, with a better changelog entry ...

> @@ -660,7 +660,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  			return -ENODEV;
>  	}
>  
> -	devinfo = kmalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
> +	devinfo = kzalloc(sizeof(struct uas_dev_info), GFP_KERNEL);
>  	if (!devinfo)
>  		return -ENOMEM;
>  

Except for this hunk, which isn't an IU and doesn't go out on the wire.

