Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1H2SKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:10:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41112 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab1H2SKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:10:10 -0400
X-Sasl-enc: HDmCT489+zMjdsIHJu5DnzCyxkjzPvlHPZ0DmS2gx32R 1314641409
Date: Mon, 29 Aug 2011 11:09:34 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Message-ID: <20110829180934.GB23618@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-44-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314469905-7058-44-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 27, 2011 at 11:31:43AM -0700, K. Y. Srinivasan wrote:
> Fix checkpatch warnings in connection.c.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/connection.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
> index ca92ca3..9e99c04 100644
> --- a/drivers/staging/hv/connection.c
> +++ b/drivers/staging/hv/connection.c
> @@ -220,11 +220,11 @@ static void process_chn_event(u32 relid)
>  	channel = relid2channel(relid);
>  
>  	spin_lock_irqsave(&channel->inbound_lock, flags);
> -	if (channel && (channel->onchannel_callback != NULL)) {
> +	if (channel && (channel->onchannel_callback != NULL))
>  		channel->onchannel_callback(channel->channel_callback_context);
> -	} else {

I agree with Joe here, if channel really was NULL, you just oopsed.

I'll apply this one, but please send me a follow-on one fixing this bug.

greg k-h
