Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1FLIOA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 04:14:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34025 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1FLIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 04:13:57 -0400
Subject: Re: [PATCH] :V2 drivers/bluetooth/bpa10x.c: missing kfrees
From: Marcel Holtmann <marcel@holtmann.org>
To: Connor Hansen <cmdkhh@gmail.com>
Cc: padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 12 Jun 2011 10:13:54 +0200
In-Reply-To: <1307828171-22010-1-git-send-email-cmdkhh@gmail.com>
References: <1307828171-22010-1-git-send-email-cmdkhh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307866435.2589.48.camel@aeonflux>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Connor,

> both bpa10x_submit_initr_urb() and bpa10x_submit_bulk_urb()
> malloc a char buffer(buf) for usb_fill_init_usb() but fail to
> free it after freeing the urb.

you do realize that URB_FREE_BUFFER flag is used?

> Likewise, bpa10x_send_frame() allocates a usb_ctrlrequest(dr)
> for sending packets but does not free it after the
> usb_fill_control_urb() call.

There is a kfree(urb->setup_packet) in the complete callback. So I am
not following where you would see a memory leak here.

Regards

Marcel


