Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab1IPSIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:08:44 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38078 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261Ab1IPSIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:08:12 -0400
X-Sasl-enc: 94KlD6rbKrhQBe6VJFeW40O9cM6DXA76hKtBaaQhaYHs 1316196491
Date: Fri, 16 Sep 2011 20:01:29 +0200
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 05/20] Staging: hv: util: Perform some service specific
 init/deinit in probe/remove
Message-ID: <20110916180129.GA25531@kroah.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-5-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315936796-20662-5-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:59:41AM -0700, K. Y. Srinivasan wrote:
> --- a/drivers/staging/hv/hv_util.c
> +++ b/drivers/staging/hv/hv_util.c
> @@ -30,9 +30,31 @@
>  #include "hyperv.h"
>  #include "hv_kvp.h"
>  
> -static u8 *shut_txf_buf;
> -static u8 *time_txf_buf;
> -static u8 *hbeat_txf_buf;
> +
> +static void shutdown_onchannelcallback(void *context);
> +static struct hv_util_service util_shutdown = {
> +	.service_name = "Shutdown channel functionality initialized\n",

That's not a name, it's a text string to send to userspace, and it's
really redundant given the other times you use this.

Please just put the name here, if you really need it (hint, you really
don't, so just drop it please.)

greg k-h
