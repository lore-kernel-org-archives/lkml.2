Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab0L0Pjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 10:39:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0L0Pjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 10:39:39 -0500
Date: Mon, 27 Dec 2010 16:39:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH 1/3] HID: picolcd: fix misuse of logical operation in
 place of bitop
In-Reply-To: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
Message-ID: <alpine.LNX.2.00.1012271638490.16569@pobox.suse.cz>
References: <1293463663-21198-1-git-send-email-dsterba@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010, David Sterba wrote:

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

Applied, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
