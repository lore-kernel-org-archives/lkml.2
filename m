Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1HWXbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:31:21 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33718 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755534Ab1HWX2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:01 -0400
X-Sasl-enc: ef3eLY8BPupAhRro/q3TCVBjQYB0FuRBPmNwYh2l+VJF 1314142080
Date: Tue, 23 Aug 2011 16:01:06 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 035/117] Staging: hv: vmbus: Introduce a function to map
 the dev_type guid to a name
Message-ID: <20110823230106.GJ9641@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-35-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310752065-27895-35-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:46:23AM -0700, K. Y. Srinivasan wrote:
> To support "human readable" sysfs attribute, introduce a function to map the
> dev_type guid to a string.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/channel_mgmt.c |   36 ++++++++++++++++++++++++++++++++++++
>  drivers/staging/hv/hyperv.h       |    2 +-
>  2 files changed, 37 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
> index 11beb41..926bc87 100644
> --- a/drivers/staging/hv/channel_mgmt.c
> +++ b/drivers/staging/hv/channel_mgmt.c
> @@ -112,6 +112,42 @@ static const uuid_le
>  
>  };
>  
> +static const char *blk_dev_type = "hv_block";
> +static const char *net_dev_type = "hv_net";
> +static const char *scsi_dev_type = "hv_scsi";
> +static const char *mouse_dev_type = "hv_mouse";
> +static const char *util_dev_type = "hv_util";

Ick, no.  There should never be any type of "central" knowledge of the
different driver names or types like this.  It should all be
self-contained within the individual drivers.

You will note that no other bus type has this type of thing, which
should have been a hint that you should not have done this...

greg k-h
