Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab2EIFyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:54:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34477 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab2EIFyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:54:17 -0400
Date: Tue, 8 May 2012 22:54:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>, khali@linux-fr.org
Subject: Re: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor
 mxt_read/write_reg to take a length
Message-ID: <20120509055411.GG10514@core.coreip.homeip.net>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, Apr 18, 2012 at 09:21:48PM +0800, Daniel Kurtz wrote:
> +	ret = i2c_transfer(client->adapter, xfer, 2);
> +	if (ret != 2) {
> +		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
> +		if (ret >= 0)
> +			ret = -EIO;
>  	}
>  
> -	return 0;
> +	return (ret == 2) ? 0 : ret;
>  }

Would prefer:

	ret = i2c_transfer(client->adapter, xfer, ARRAY_SIZE(xfer));
	if (ret != ARRAY_SIZE(xfer)) {
		if (ret >= 0)
			ret = -EIO;
		dev_err(&client->dev, "i2c read reg failed (%d)\n", ret);
		return ret;
	}

	return 0;


Or maybe we need i2c_transfer_exact() wrapper? Jean?

Thanks.

-- 
Dmitry
