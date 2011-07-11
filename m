Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab1GKF5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:57:40 -0400
Received: from mail.perches.com ([173.55.12.10]:3864 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726Ab1GKF5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:57:39 -0400
Subject: Re: [PATCH 3/3] Staging: comedi: fix brace coding style issue in
 pcl818.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1310364039-17345-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH 3/3]Staging: comedi: fix brace coding style issue in pcl818.c>
	 <1310364039-17345-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 22:57:38 -0700
Message-ID: <1310363858.2446.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 11:30 +0530, Ravishankar wrote:
> This is a patch to the pcl818.c file that fixes up a brace warning found by the checkpatch.pl tool
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
[]
> @@ -1301,11 +1301,10 @@ static void setup_channel_list(struct comedi_device *dev,
>  */
>  static int check_single_ended(unsigned int port)
>  {
> -	if (inb(port + PCL818_STATUS) & 0x20) {
> +	if (inb(port + PCL818_STATUS) & 0x20)
>  		return 1;
> -	} else {
> +	else
>  		return 0;
> -	}
>  }

I'd prefer this become:

static bool check_single_ended()
{
	if (...)
		return true;
	return false;
}


