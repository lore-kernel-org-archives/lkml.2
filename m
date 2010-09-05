Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab0IEPpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 11:45:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62951 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0IEPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=U2TXVJtCnQuZfMq3lmoOAqtyoET2ygtr42cnBndjiLNS6koNfGaafoERiRzp5mzZj7
         abDIsK3hY7JicZXAXIZHmhXbYJ87G8Dn6i5Vu3dSkPEOLb3666hu0WC8oSplYNrC5JM7
         e3yQmLOBJPkbFrH5FCcWNBetQuBXGStbxqY28=
Date: Sun, 5 Sep 2010 18:46:11 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: lrg@slimlogic.co.uk, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] tlv320aic3x: potential null dereference
Message-Id: <20100905184611.ac387439.jhnikula@gmail.com>
In-Reply-To: <4C8244AD.6090900@gmail.com>
References: <4C8244AD.6090900@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Sep 2010 15:07:57 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> stanse found a potential null dereference:
> aic3x_i2c_probe
>   -> struct aic3x_setup_data *setup = pdata->setup;
>   -> -- pdata can't be null now--
>   -> if (pdata && pdata->gpio_reset >= 0)
> 
> But there is another check for pdata == NULL. Could take a look and fix
> it (either remove the check or move the assignement inside the if)?
> 
Thanks, this is a bug that got introduced recently to ASoC tree.
Fortunately is not in mainline. I'll send a fix in a minute to
alsa-devel.


-- 
Jarkko
