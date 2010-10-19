Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0JSPIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:08:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47031 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752513Ab0JSPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:08:18 -0400
Date: Tue, 19 Oct 2010 11:08:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: USB list <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] usb: dummy_hcd code simplification
In-Reply-To: <1287495641-22802-1-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1010191056470.1786-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, Tatyana Brokhman wrote:

> Take handling of the control requests out from dummy_timer to a different
> function.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/usb/gadget/dummy_hcd.c |  250 +++++++++++++++++++++-------------------
>  1 files changed, 134 insertions(+), 116 deletions(-)
> 
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index dc65462..ff93fea 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -1195,6 +1195,138 @@ static struct dummy_ep *find_endpoint (struct dummy *dum, u8 address)
>  #define Ep_Request	(USB_TYPE_STANDARD | USB_RECIP_ENDPOINT)
>  #define Ep_InRequest	(Ep_Request | USB_DIR_IN)
>  
> +
> +/**
> + * handle_control_request() - handles all control transferes
> + *

There should not be a blank line here.

> + * @dum - pointer to dummy (the_controller)
> + * @urb - the urb request to handle

Where's the line for "setup"?

> + * @status - pointer to request handling status

In each of these there should be a ':' following the variable name,
not a space and a '-'.  Honestly, I can't see why you have so much
trouble copying the format of existing kerneldoc entries.

> + *
> + * Return 0 - if the request was handled
> + *	  1 - if the request wasn't handles
> + *	  error code on error
> + */
> +static int handle_control_request(struct dummy *dum, struct urb *urb,
> +				  struct usb_ctrlrequest setup,

Don't pass "setup" by value!  Pass it by reference, i.e., pass a 
pointer to the "setup" variable in dummy_timer().

> +				  int *status)
> +{

The rest of this is okay.

Alan Stern

