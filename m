Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab0KRQGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:06:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37862 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759404Ab0KRQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:06:39 -0500
Date: Thu, 18 Nov 2010 11:06:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <1290085052-4977-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1011181045430.1801-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Tatyana Brokhman wrote:

> USB 3.0 hub includes 2 hubs - HS and SS ones.
> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).

Hmm.  A quick comparison with the original source shows that you
neglected to add code for SuperSpeed transfers to periodic_bytes() and
show_urb().

> @@ -1352,6 +1544,9 @@ static void dummy_timer (unsigned long _dum)
>  	case USB_SPEED_HIGH:
>  		total = 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>  		break;
> +	case USB_SPEED_SUPER:
> +		total = 400 << 20; /* 400MB = 400*(2^20) bytes */
> +		break;

Somehow I doubt that SuperSpeed USB, quick though it is, can transfer
400 MB in one millisecond.  Where did you get that number from?

I can't find the appropriate table in the USB-3.0 spec (it might not be
there at all), but with a bus transfer rate of 500 million bytes/s it
seems clear that you can't transfer more than 500000 bytes per frame.  
The actual limit must be lower than that, maybe something like 1024
bytes/packet * 60 packets/uframe * 8 uframes/frame = 491520 
bytes/frame.

Alan Stern

