Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143Ab2GLOoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:44:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34516 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932578Ab2GLOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:44:08 -0400
Date: Thu, 12 Jul 2012 10:44:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb/host/ehci-hub: Fix the issue EG20T USB host
 controller has long resuming time, when pen drive is attached.
In-Reply-To: <1342061617-5630-1-git-send-email-tomoya.rohm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1207121041470.1413-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Tomoya MORINAGA wrote:

> Intel EG20T USB host controller does not send SOF in resuming time
> after suspending, if the FLR bit was not cleared. When pen drive is
> attached, the controller has a long resuming time to try re-connect
> it. This patch clear the FLR bit in suspending time for fixing the
> issue.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
> v2: Update comments from Alan Stern
> 	Add patch description
> 	Always clear the STS_FLR flag.
> ---
>  drivers/usb/host/ehci-hub.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index fc9e7cc..818a2f1 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -318,6 +318,7 @@ static int ehci_bus_suspend (struct usb_hcd *hcd)
>  	ehci_readl(ehci, &ehci->regs->intr_enable);
>  
>  	ehci->next_statechange = jiffies + msecs_to_jiffies(10);
> +	ehci_writel(ehci, STS_FLR, &ehci->regs->status);
>  	spin_unlock_irq (&ehci->lock);

You need to add a comment to the code also.  Otherwise, a few years
from now somebody will see that line, realize it doesn't do anything
important, and get rid of it.

Alan Stern

