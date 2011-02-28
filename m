Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1B1JHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:07:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:54704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab1B1JHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:07:43 -0500
Date: Mon, 28 Feb 2011 10:07:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr,
        peter.hutterer@who-t.net
Subject: Re: [PATCH 2/2] HID: ntrig mapping more firmware id bits
In-Reply-To: <1298610932-21957-2-git-send-email-rafi@seas.upenn.edu>
Message-ID: <alpine.LNX.2.00.1102281007060.2160@pobox.suse.cz>
References: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu> <1298610932-21957-2-git-send-email-rafi@seas.upenn.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011, Rafi Rubin wrote:

> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> ---
> Two new firmwares supply hints to map three more bits of the raw
> firmware id code.
> 
> Confirmation, and perhaps the rest of the mapping from someone with both
> the knowledge and legal rights would be appreciated.  Not that I mind
> the pleasure of the puzzle being filled in slowly over time.

Micki, I guess we are waiting for your Signed-off-by: here ... could you 
please comment on that?

Thanks.

> ---
>  drivers/hid/hid-ntrig.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 616f091..3ce4624 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -96,15 +96,15 @@ struct ntrig_data {
>   */
>  static int ntrig_version_string(unsigned char *raw, char *buf)
>  {
> -	__u8 a =  (raw[1] & 0x0e) >> 1;
> +	__u8 a =  (raw[1] & 0x1e) >> 1;
>  	__u8 b =  (raw[0] & 0x3c) >> 2;
>  	__u8 c = ((raw[0] & 0x03) << 3) | ((raw[3] & 0xe0) >> 5);
>  	__u8 d = ((raw[3] & 0x07) << 3) | ((raw[2] & 0xe0) >> 5);
> -	__u8 e =   raw[2] & 0x07;
> +	__u8 e =   raw[2] & 0x1f;
>  
>  	/*
>  	 * As yet unmapped bits:
> -	 * 0b11000000 0b11110001 0b00011000 0b00011000
> +	 * 0b11000000 0b11100001 0b00000000 0b00011000
>  	 */
>  
>  	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
> -- 
> 1.7.2.3
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
