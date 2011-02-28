Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1B1Lws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:52:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65412 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1B1Lwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MBl71Pll1UXu3DOfARFrA5qw3VA5nDeDYqEcHuzQEDtyRpiEVliJTcmnhwMJFR9FB7
         rWCVhnARZqZw4/GTNQ8an3O8ZyTcN/aOAiYEx05zEViF0iZlNwL/6MIjI3tsxUxAG54f
         4jQOJa+Cqtyu4nw1EHagDbWYHiVqIIHMTyzM8=
Date: Mon, 28 Feb 2011 14:52:25 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Seth Heasley <seth.heasley@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com,
        toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH RESEND v2] i2c-eg20t: support new device OKI
 SEMICONDUCTOR ML7213 IOH
Message-ID: <20110228115225.GB9075@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
	Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
	Seth Heasley <seth.heasley@intel.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, qi.wang@intel.com,
	yong.y.wang@intel.com, joel.clark@intel.com, kok.howg.ewe@intel.com,
	toshiharu-linux@dsn.okisemi.com
References: <1298876072-15452-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298876072-15452-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 03:54:32PM +0900, Tomoya MORINAGA wrote:
> -	ret = i2c_add_adapter(&(adap_info->pch_data.pch_adapter));
> +		pch_adap->dev.parent = &pdev->dev;
>  
> -	if (ret) {
> -		pch_pci_err(pdev, "i2c_add_adapter FAILED\n");
> -		goto err_i2c_add_adapter;
> -	}
> +		ret = i2c_add_adapter(pch_adap);
> +		if (ret) {
> +			pch_pci_err(pdev, "i2c_add_adapter[ch:%d] FAILED\n", i);
> +			goto err_i2c_add_adapter;

I think goto err_request_irq was intended here.  On a side note, it's
always better to name goto destinations after the destination instead
of the starting point.  In this case, we have two gotos to one
destination and the label err_request_irq makes no sense.

regards,
dan carpenter

