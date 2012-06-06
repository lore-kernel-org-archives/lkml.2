Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2FFP3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:29:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756379Ab2FFP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:29:45 -0400
Date: Wed, 6 Jun 2012 11:29:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: James.Bottomley@HansenPartnership.com, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 1/3] scsi: set to WCE if usb cache quirk is present.
In-Reply-To: <1338985224-9684-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206061126280.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Namjae Jeon wrote:

> Make use of USB quirk method to identify such HDD while reading the cache status in sd_probe(). If cache quirk is present for the HDD, lets assume that cache is enabled and make WCE bit equal to 1.

Your lines should be wrapped after 72 columns or so.

Calling this a "quirk" sounds strange.  Really, your new flag indicates 
that WCE should default to "on" instead of "off".  How about calling it 
"wce_default_on" instead of "wce_quirk"?

> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -152,6 +152,7 @@ struct scsi_device {
>  	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
>  	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
>  	unsigned is_visible:1;	/* is the device visible in sysfs */
> +	unsigned wce_quirk:1; /* cache read page is not available */

The comment is wrong.  There's no need for a quirk to indicate the
cache page is unavailable; the driver already knows when the page is
unavailable.  Rather, the quirk indicates that WCE should default to
"on".

Alan Stern

