Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab1FWHwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:52:17 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:36484 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1FWHwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:52:16 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] i2c-eg20t : Fix the issue of Combined R/W transfer mode
Date: Thu, 23 Jun 2011 09:52:08 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Qi Wang <qi.wang@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
References: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1308813430-2697-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106230952.09286.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 09:17:10 Tomoya MORINAGA wrote:
> @@ -672,7 +672,7 @@ static s32 pch_i2c_xfer(struct i2c_adapter *i2c_adap,
>  	/* transfer not completed */
>  	adap->pch_i2c_xfer_in_progress = true;
> 
> -	for (i = 0; i < num; i++) {
> +	for (i = 0; i < num && ret >= 0; i++) {
>  		pmsg = &msgs[i];
>  		pmsg->flags |= adap->pch_buff_mode_en;
>  		status = pmsg->flags;

Do you have any other local pending patches which are not in git yet? I can't 
find this for loop in current master.

Regards,
Alexander
