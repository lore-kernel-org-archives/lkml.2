Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1H2RxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:53:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46556 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594Ab1H2RxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:53:02 -0400
X-Sasl-enc: +bwO0LmQkoB/aCInUf+l96C8jjwexHbIevVQRksbEEyE 1314640381
Date: Mon, 29 Aug 2011 10:52:41 -0700
From: Greg KH <greg@kroah.com>
To: Manohar Vanga <manohar.vanga@cern.ch>
Cc: gregkh@suse.de, martyn.welch@ge.com, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vme: add struct vme_dev for VME devices
Message-ID: <20110829175241.GC10250@kroah.com>
References: <1314608570-32766-1-git-send-email-manohar.vanga@cern.ch>
 <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314608570-32766-3-git-send-email-manohar.vanga@cern.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:02:49AM +0200, Manohar Vanga wrote:
> --- a/drivers/staging/vme/vme_bridge.h
> +++ b/drivers/staging/vme/vme_bridge.h
> @@ -115,9 +115,8 @@ struct vme_bridge {
>  	struct list_head bus_list; /* list of VME buses */
>  	struct module *owner;	/* module that owns the bridge */
>  
> -	struct device dev[VME_SLOTS_MAX];	/* Device registered with
> -						 * device model on VME bus
> -						 */
> +	struct vme_dev dev[VME_SLOTS_MAX];	/* Device registered
> +						 * on VME bus */

Overall, this is the right way to go, using a vme_dev.

BUT, you should never have a static list of devices, these should be
pointers, not actual structures here, otherwise your reference counting
just got all messed up and is wrong.

And yes, I know you didn't create the code this way, but it needs to be
fixed _before_ you make this kind of a change.

thanks,

greg k-h
