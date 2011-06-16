Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1FPPR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:17:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40329 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756715Ab1FPPRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:17:22 -0400
Date: Thu, 16 Jun 2011 11:17:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 2/5] usb:dummy_hcd: connect/disconnect test support
In-Reply-To: <1308231068-24038-3-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106161114320.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Tatyana Brokhman wrote:

> This implementation adds a new proprietary device control requests (to be
> handled by the dummy_hcd) that initiates a connect/disconnect sequence.
> The bRequest value of the new control request is 0x52.
> It is used by the user-space Unit testing application.
> 
> Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>

> @@ -1534,6 +1572,10 @@ static int handle_control_request(struct dummy_hcd *dum_hcd, struct urb *urb,
>  			*status = 0;
>  		}
>  		break;
> +	case 0x52:	/* UT: Connect/disconnect the device */
> +		schedule_work(&dum_hcd->conn_disc_work);
> +		ret_val = 0;
> +		break;
>  	}
>  	return ret_val;
>  }

I forgot to mention...  You need to test setup->bRequestType.

Alan Stern

