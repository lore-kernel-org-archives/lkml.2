Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2JAI0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:26:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab2JAI0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:26:01 -0400
Date: Mon, 1 Oct 2012 10:25:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: HID: picoLCD: optimize for inactive debugfs
In-Reply-To: <20120930220419.01408e0e@neptune.home>
Message-ID: <alpine.LNX.2.00.1210011025490.27440@pobox.suse.cz>
References: <20120930220419.01408e0e@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2012, Bruno Prémont wrote:

> Matthieu CASTET adjusted picolcd_debug_out_report() to only operate when
> there is an active listener on debugfs for events.
> 
> His change got lost while splitting hid_picolcd.c, restore it.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
> 
> 
> diff --git a/drivers/hid/hid-picolcd_debugfs.c b/drivers/hid/hid-picolcd_debugfs.c
> index 6ef03be..4809aa1 100644
> --- a/drivers/hid/hid-picolcd_debugfs.c
> +++ b/drivers/hid/hid-picolcd_debugfs.c
> @@ -402,7 +402,7 @@ void picolcd_debug_out_report(struct picolcd_data *data,
>  #define BUFF_SZ 256
>  
>  	/* Avoid unnecessary overhead if debugfs is disabled */
> -	if (!hdev->debug_events)
> +	if (list_empty(&hdev->debug_list))
>  		return;
>  
>  	buff = kmalloc(BUFF_SZ, GFP_ATOMIC);

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
