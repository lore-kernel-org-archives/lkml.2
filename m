Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367Ab1BNSdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:33:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:35013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1BNSdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:33:51 -0500
Date: Mon, 14 Feb 2011 10:33:22 -0800
From: Greg KH <gregkh@suse.de>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: haiyangz@microsoft.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        Abhishek Kane <v-abkane@microsoft.com>,
        "K.Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] Staging: hv: Use list_entry for msg_info and remove
 associated comment
Message-ID: <20110214183322.GA27858@suse.de>
References: <1297708537-15981-1-git-send-email-hjanssen@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297708537-15981-1-git-send-email-hjanssen@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 10:35:37AM -0800, Hank Janssen wrote:
> Change code to use list_entry api. And removed comment
> suggesting that change.
> 
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/channel_mgmt.c |   17 +++++++++--------
>  1 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
> index a9c9d49..6c497e9 100644
> --- a/drivers/staging/hv/channel_mgmt.c
> +++ b/drivers/staging/hv/channel_mgmt.c
> @@ -580,8 +580,9 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
>  	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
>  
>  	list_for_each(curr, &vmbus_connection.chn_msg_list) {
> -/* FIXME: this should probably use list_entry() instead */
> -		msginfo = (struct vmbus_channel_msginfo *)curr;
> +		msginfo = list_entry(curr, struct vmbus_channel_msginfo,
> +				msglistentry);

How about using list_for_each_entry() instead?  That's the "preferred"
way to do things these days, and it saves you an extra line of code :)

thanks,

greg k-h
