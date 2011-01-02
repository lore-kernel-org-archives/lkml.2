Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1ABXMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 18:12:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:54635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1ABXMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 18:12:19 -0500
Date: Mon, 3 Jan 2011 00:12:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH] HID, hid-picolcd: Fix memory leak in
 picolcd_debug_out_report()
In-Reply-To: <alpine.LNX.2.00.1101022212030.11481@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1101030012060.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101022212030.11481@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Jan 2011, Jesper Juhl wrote:

> We have a memory leak in 
> drivers/hid/hid-picolcd.c::picolcd_debug_out_report() in an error path..
> We are not always freeing the memory allocated to 'buff' - this patch 
> makes sure we always kfree() what we allocate with kmalloc() when it is 
> no longer needed.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  hid-picolcd.c |    1 +
>  1 file changed, 1 insertion(+)
> 
>   compile tested only.
> 
> diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> index bc2e077..ad6539a 100644
> --- a/drivers/hid/hid-picolcd.c
> +++ b/drivers/hid/hid-picolcd.c
> @@ -1867,6 +1867,7 @@ static void picolcd_debug_out_report(struct picolcd_data *data,
>  			report->id, raw_size);
>  	hid_debug_event(hdev, buff);
>  	if (raw_size + 5 > sizeof(raw_data)) {
> +		kfree(buff);
>  		hid_debug_event(hdev, " TOO BIG\n");
>  		return;
>  	} else {
> 

Good catch, applied, thanks Jesper.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
