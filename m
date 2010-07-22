Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0GVXo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:44:27 -0400
Received: from kroah.org ([198.145.64.141]:41480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab0GVXoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:44:25 -0400
Date: Thu, 22 Jul 2010 16:39:16 -0700
From: Greg KH <greg@kroah.com>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Emese Revfy <re.emese@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/6] Driver core: Fix potential memory leak
Message-ID: <20100722233916.GA674@kroah.com>
References: <1279836546-26913-1-git-send-email-ppannuto@codeaurora.org>
 <1279836546-26913-2-git-send-email-ppannuto@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279836546-26913-2-git-send-email-ppannuto@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:09:01PM -0700, Patrick Pannuto wrote:
> In both of the 'goto out' cases, priv has already
> been allocated and assigned to bus->p. We reset
> bus->p to NULL, but neglect to free bus->p
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  drivers/base/bus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 12eec3f..eb1b7fa 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -945,8 +945,8 @@ bus_devices_fail:
>  	bus_remove_file(bus, &bus_attr_uevent);
>  bus_uevent_fail:
>  	kset_unregister(&bus->p->subsys);
> -	kfree(bus->p);
>  out:
> +	kfree(bus->p);

This fix is already in my tree.

thanks,

greg k-h
