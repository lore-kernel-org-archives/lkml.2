Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab2JSNNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:13:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19480 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab2JSNNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:13:09 -0400
Date: Fri, 19 Oct 2012 09:00:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, dmitry.torokhov@gmail.com
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 5/5] xen-kbdfront: handle backend CLOSED without CLOSING
Message-ID: <20121019130059.GE26830@phenom.dumpdata.com>
References: <507FD39F.4060601@citrix.com>
 <1350554618-14582-5-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350554618-14582-5-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:03:38AM +0100, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> CLOSED.  If a backend does transition to CLOSED too soon then the
> frontend may not see the CLOSING state and will not properly shutdown.
> 
> So, treat an unexpected backend CLOSED state the same as CLOSING.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> Cc: linux-input@vger.kernel.org
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Hey Dmitry,

Should I prep a git pull for you for this or are you OK giving
an Ack for me to put this patch in my git pull for Linus?

Thx.
> ---
>  drivers/input/misc/xen-kbdfront.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> index 02ca868..6f7d990 100644
> --- a/drivers/input/misc/xen-kbdfront.c
> +++ b/drivers/input/misc/xen-kbdfront.c
> @@ -311,7 +311,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
>  	case XenbusStateReconfiguring:
>  	case XenbusStateReconfigured:
>  	case XenbusStateUnknown:
> -	case XenbusStateClosed:
>  		break;
>  
>  	case XenbusStateInitWait:
> @@ -350,6 +349,10 @@ InitWait:
>  
>  		break;
>  
> +	case XenbusStateClosed:
> +		if (dev->state == XenbusStateClosed)
> +			break;
> +		/* Missed the backend's CLOSING state -- fallthrough */
>  	case XenbusStateClosing:
>  		xenbus_frontend_closed(dev);
>  		break;
> -- 
> 1.7.2.5
