Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2H0PIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:08:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab2H0PIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:08:02 -0400
Date: Mon, 27 Aug 2012 08:07:54 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@bitmath.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [PATCH] HID: hid-debug: Show rdesc for unclaimed devices
In-Reply-To: <1345573364-341-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1208270807420.22447@pobox.suse.cz>
References: <1345573364-341-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Henrik Rydberg wrote:

> Since commit a7197c2e, the raw report descriptor is available also for
> unclaimed devices. This patchs make it show in the rdesc debugfs node.

Definitely nice to have. Applied, thanks Henrik.

> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-debug.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
> index 01dd9a7..933fff0 100644
> --- a/drivers/hid/hid-debug.c
> +++ b/drivers/hid/hid-debug.c
> @@ -911,15 +911,21 @@ static void hid_dump_input_mapping(struct hid_device *hid, struct seq_file *f)
>  
>  }
>  
> -
>  static int hid_debug_rdesc_show(struct seq_file *f, void *p)
>  {
>  	struct hid_device *hdev = f->private;
> +	const __u8 *rdesc = hdev->rdesc;
> +	unsigned rsize = hdev->rsize;
>  	int i;
>  
> +	if (!rdesc) {
> +		rdesc = hdev->dev_rdesc;
> +		rsize = hdev->dev_rsize;
> +	}
> +
>  	/* dump HID report descriptor */
> -	for (i = 0; i < hdev->rsize; i++)
> -		seq_printf(f, "%02x ", hdev->rdesc[i]);
> +	for (i = 0; i < rsize; i++)
> +		seq_printf(f, "%02x ", rdesc[i]);
>  	seq_printf(f, "\n\n");
>  
>  	/* dump parsed data and input mappings */
> -- 
> 1.7.11.5
> 

-- 
Jiri Kosina
SUSE Labs
