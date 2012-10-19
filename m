Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2JSNMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:12:25 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22353 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2JSNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:12:23 -0400
Date: Fri, 19 Oct 2012 09:00:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>, FlorianSchandinat@gmx.de
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH 4/5] xen-fbfront: handle backend CLOSED without CLOSING
Message-ID: <20121019130011.GD26830@phenom.dumpdata.com>
References: <507FD39F.4060601@citrix.com>
 <1350554618-14582-4-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350554618-14582-4-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:03:37AM +0100, David Vrabel wrote:
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
> Cc: linux-fbdev@vger.kernel.org
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Hey Florian,

Should I prep a git pull for you with this or would it be OK
if I just have your Ack to put this in my git pull for Linus?

Thanks!
> ---
>  drivers/video/xen-fbfront.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
> index b7f5173..917bb56 100644
> --- a/drivers/video/xen-fbfront.c
> +++ b/drivers/video/xen-fbfront.c
> @@ -641,7 +641,6 @@ static void xenfb_backend_changed(struct xenbus_device *dev,
>  	case XenbusStateReconfiguring:
>  	case XenbusStateReconfigured:
>  	case XenbusStateUnknown:
> -	case XenbusStateClosed:
>  		break;
>  
>  	case XenbusStateInitWait:
> @@ -670,6 +669,10 @@ InitWait:
>  		info->feature_resize = val;
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
