Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab1HRGiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:38:25 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64265 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1HRGiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:38:23 -0400
Date: Wed, 17 Aug 2011 23:38:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 3/6] Input: elantech - packet checking for v2 hardware
Message-ID: <20110818063818.GC10093@core.coreip.homeip.net>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
 <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313632629-23603-4-git-send-email-jj_ding@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 09:57:06AM +0800, JJ Ding wrote:
> For v2 hardware, there is no real parity check, but we can still check
> some constant bits for data integrity.
> 
> Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
> ---
>  drivers/input/mouse/elantech.c |   26 +++++++++++++++++++++++---
>  1 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index cf41f23..032181c 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -376,6 +376,25 @@ static int elantech_check_parity_v1(struct psmouse *psmouse)
>  	       etd->parity[packet[3]] == p3;
>  }
>  
> +static int packet_simple_check_v2(struct psmouse *psmouse)
> +{
> +	struct elantech_data *etd = psmouse->private;
> +	unsigned char *packet = psmouse->packet;
> +
> +	if (etd->reports_pressure)
> +		return (packet[0] & 0x0c) == 0x04 &&
> +		       (packet[3] & 0x0f) == 0x02;
> +
> +	if ((packet[0] & 0xc0) == 0x80)
> +		return (packet[0] & 0x0c) == 0x0c &&
> +		       (packet[3] & 0x0e) == 0x08;
> +
> +	return (packet[0] & 0x3c) == 0x3c &&
> +	       (packet[1] & 0xf0) == 0x00 &&
> +	       (packet[3] & 0x3e) == 0x38 &&
> +	       (packet[4] & 0xf0) == 0x00;

Can we please spell out the assumptions under which we decide that
packet is invalid?

Thanks.

-- 
Dmitry
