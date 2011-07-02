Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1GBUfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 16:35:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40254 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755814Ab1GBUfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 16:35:16 -0400
Date: Sat, 2 Jul 2011 16:35:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthieu CASTET <castet.matthieu@free.fr>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] EHCI : introduce a common ehci_setup
In-Reply-To: <1309633186-31693-1-git-send-email-castet.matthieu@free.fr>
Message-ID: <Pine.LNX.4.44L0.1107021633160.16190-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jul 2011, Matthieu CASTET wrote:

> This allow to clean duplicated code in most of SOC driver.
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> ---
>  drivers/usb/host/ehci-hcd.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
> index f8030ee..f990b0f 100644
> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -763,6 +763,35 @@ static int ehci_run (struct usb_hcd *hcd)
>  	return 0;
>  }
>  
> +static int __maybe_unused ehci_setup (struct usb_hcd *hcd)
> +{
> +	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> +	int retval;

...

> +}
> +

Instead of putting this routine in ehci-hcd.c, where it will silently 
use up unnecessary codespace on thousands or millions of desktop 
systems, why not put it into a new separate source file?  Then the SOC 
drivers can #include that file.

Alan Stern

