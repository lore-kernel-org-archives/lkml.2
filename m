Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab2FJRgz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:36:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:47460 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753872Ab2FJRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:36:53 -0400
Date: Sun, 10 Jun 2012 13:36:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Namjae Jeon <linkinjeon@gmail.com>
cc: James.Bottomley@HansenPartnership.com, <gregkh@linuxfoundation.org>,
        <mdharm-usb@one-eyed-alien.net>, <sshtylyov@mvista.com>,
        <bvanassche@acm.org>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/4] usb: storage: add support for write cache quirk
 on usb hdd
In-Reply-To: <1339291826-2547-1-git-send-email-linkinjeon@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206101335510.31367-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2012, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce
> by detecting write cache quirk in quirk list when plugging usb hdd.

> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -64,7 +64,9 @@
>  	US_FLAG(NO_READ_CAPACITY_16,	0x00080000)		\
>  		/* cannot handle READ_CAPACITY_16 */		\
>  	US_FLAG(INITIAL_READ10,	0x00100000)			\
> -		/* Initial READ(10) (and others) must be retried */
> +		/* Initial READ(10) (and others) must be retried */	\
> +	US_FLAG(WRITE_CACHE,	0x00200000)			\
> +		/* Write Cache status is not available */

The documentation for the new flag should be added in the same patch 
along with the flag itself.  There's no reason to have separate 
patches.

Alan Stern

