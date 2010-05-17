Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab0EQI1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:27:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:50597 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0EQI1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:27:39 -0400
Date: Mon, 17 May 2010 10:27:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 21/37] drivers/hid: Use kmemdup
In-Reply-To: <Pine.LNX.4.64.1005152319150.21345@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.1005171026500.28092@pobox.suse.cz>
References: <Pine.LNX.4.64.1005152319150.21345@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to,size,flag;
> statement S;
> @@
> 
> -  to = \(kmalloc\|kzalloc\)(size,flag);
> +  to = kmemdup(from,size,flag);
>    if (to==NULL || ...) S
> -  memcpy(to, from, size);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/hid/hid-core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff -u -p a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -653,10 +653,9 @@ int hid_parse_report(struct hid_device *
>  	if (device->driver->report_fixup)
>  		device->driver->report_fixup(device, start, size);
>  
> -	device->rdesc = kmalloc(size, GFP_KERNEL);
> +	device->rdesc = kmemdup(start, size, GFP_KERNEL);
>  	if (device->rdesc == NULL)
>  		return -ENOMEM;
> -	memcpy(device->rdesc, start, size);
>  	device->rsize = size;
>  
>  	parser = vmalloc(sizeof(struct hid_parser));

Applied, thanks Julia.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
