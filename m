Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab1EFJ37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 05:29:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35052 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab1EFJ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 05:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gDHt20SqqE7PIW4V8d/gqBT1sNZsGHdJyIZbtB+KOh0AjnjZLk0DepkQoUAD1FLXyX
         A84fIjGBMiPhnjXYIPsxoh/70wREy+lmKR+CRaWOCtaots6WCsOdt+HmOZ/EwmnTvs8M
         C7xUO+lm65yLkc8jobuFNcG+KqnqLr7x/GMPM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1105051547000.28291@pobox.suse.cz>
References: <20110429115948.e949234b.sfr@canb.auug.org.au>
	<BANLkTikJ5CVvS+P17T_Mhtqyb29vpDcmvw@mail.gmail.com>
	<alpine.LNX.2.00.1105051547000.28291@pobox.suse.cz>
Date: Fri, 6 May 2011 11:29:43 +0200
X-Google-Sender-Auth: lmFcEUl84HLcvSSgF2pg02AHkoc
Message-ID: <BANLkTimHgUorm4HKuX7veUNR6M1o9LiTNA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the ux500-core tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/5 Jiri Kosina <jkosina@suse.cz>:
> On Fri, 29 Apr 2011, Linus Walleij wrote:
>>
>> I rewrote the driver completely so likely it will rather be dropped, but
>> please check! I'll be happy to carry any patches.
>
> Seems to me that all the calls to request_mem_region() and
> release_mem_region() still need the resource_size() fixup even in the new
> driver.

OK I went in and tweaked the patch like this:

	if (request_mem_region(gpio->memres->start,
			       resource_size(gpio->memres),
			       "GPIO Controller")
	    == NULL) {
		dev_err(gpio->dev, "could not reserve GPIO memory region\n");
		err = -ENODEV;
		goto err_no_ioregion;
	}
(...)
err_no_ioremap:
	release_mem_region(gpio->memres->start, resource_size(gpio->memres));
(...)
	release_mem_region(gpio->memres->start,
			   resource_size(gpio->memres));

It'll appear in the next tree tomorrow or so. OK?

Yours,
Linus Walleij
