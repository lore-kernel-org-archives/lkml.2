Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab0LPRhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:37:36 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:61902 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab0LPRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tBAL8fzl/Xuos7G7C3i7qxT41i/P0/ibFHzLqCCUdMz6yGuTngDurtewr3EorhnoHq
         qX8gGc3ZZBRPhgZCpbZM/zj6c65k1Z9vDEydodX3PzULbPHNSq4dz9KrCjytLbhbZ4EC
         xNJ/ZWXzc1ot9BugJ/uq7J8LCdo5tW8Goc6b8=
Date: Thu, 16 Dec 2010 09:37:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] leds: leds-pca9532 cleanups
Message-ID: <20101216173726.GC28364@core.coreip.homeip.net>
References: <1292490353.9368.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292490353.9368.2.camel@mola>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 05:05:53PM +0800, Axel Lin wrote:
> >From 6244111ba78a6768ded3fedf8967b6bc891fa757 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Thu, 16 Dec 2010 15:41:55 +0800
> Subject: [PATCH] leds: leds-pca9532 cleanups
> 
> This patch includes below fixes:
> 1. Remove unneeded input_free_device() after input_unregister_device().
> 2. Use "while (--i >= 0)" instead of "if (i > 0) for (i = i - 1; i >= 0; i--)"
>    for reclaim resources in pca9532_configure() error path.
>    I think this change improves readability.

The whole chunk should be in a separate function, like

void pca9532_destroy_devices(struct pca9532_data *data, int n_devs);

That can be called from both pca9532_configure() and pca9532_remove().

For the input change:

	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

-- 
Dmitry
