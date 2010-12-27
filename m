Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0L0Vse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:48:34 -0500
Received: from legolas.restena.lu ([158.64.1.34]:55608 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab0L0Vsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:48:33 -0500
Date: Mon, 27 Dec 2010 22:47:58 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: David Sterba <dsterba@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/3] HID: picolcd: fix misuse of logical operation in
 place of bitop
Message-ID: <20101227224758.79f0f3c5@neptune.home>
In-Reply-To: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
References: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for spotting,

Acked-by: Bruno Prémont <bonbons@linux-vserver.org>

On Mon, 27 December 2010 David Sterba <dsterba@suse.cz> wrote:
> CC: Bruno Prémont <bonbons@linux-vserver.org>
> CC: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  drivers/hid/hid-picolcd.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> index bc2e077..0aff3cd 100644
> --- a/drivers/hid/hid-picolcd.c
> +++ b/drivers/hid/hid-picolcd.c
> @@ -1544,7 +1544,7 @@ static ssize_t picolcd_debug_eeprom_read(struct file *f, char __user *u,
>  
>  	/* prepare buffer with info about what we want to read (addr & len) */
>  	raw_data[0] = *off & 0xff;
> -	raw_data[1] = (*off >> 8) && 0xff;
> +	raw_data[1] = (*off >> 8) & 0xff;
>  	raw_data[2] = s < 20 ? s : 20;
>  	if (*off + raw_data[2] > 0xff)
>  		raw_data[2] = 0x100 - *off;
> @@ -1583,7 +1583,7 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
>  
>  	memset(raw_data, 0, sizeof(raw_data));
>  	raw_data[0] = *off & 0xff;
> -	raw_data[1] = (*off >> 8) && 0xff;
> +	raw_data[1] = (*off >> 8) & 0xff;
>  	raw_data[2] = s < 20 ? s : 20;
>  	if (*off + raw_data[2] > 0xff)
>  		raw_data[2] = 0x100 - *off;
