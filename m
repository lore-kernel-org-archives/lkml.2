Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab1AJPpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:45:17 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1AJPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eWfABr2ksf84EiBmzr/hBGq4qYnxrhgSCMrf0Nvl08ewA2ziHj1Ts9bp5Pu6lkYEId
         82GLEPZCVmKq8YjKLuSMKUcIfvTvumm6TgY74sYnKkY1hS8hJzz+2EYrcEZ58l3yiCCp
         pEkO8aykWgxk05w/KwjgZLXs2TlstPqf0VJMU=
MIME-Version: 1.0
In-Reply-To: <1294670535-9059-1-git-send-email-gadiyar@ti.com>
References: <1294670535-9059-1-git-send-email-gadiyar@ti.com>
Date: Mon, 10 Jan 2011 23:43:37 +0800
Message-ID: <AANLkTik4MMsGcKbRO_CnCStgvmRinYb3kytv0-U36c2r@mail.gmail.com>
Subject: Re: [PATCH] arm: omap4: pandaboard: turn on PHY reference clock at init
From: Ming Lei <tom.leiming@gmail.com>
To: Anand Gadiyar <gadiyar@ti.com>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Felipe Balbi <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Benoit Cousson <b-cousson@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/1/10 Anand Gadiyar <gadiyar@ti.com>:
> The SMSC 3320 USB PHY on the OMAP4 Pandaboard needs a 19.2 MHz
> reference clock. This clock is provided from the OMAP4's fref_clk3
> pad.
>
> Recent changes to clock44xx_data.c made the clock framework aware
> of the existence of these fref_clk[i] lines. If the option
> CONFIG_OMAP_RESET_CLOCKS is enabled in the kernel, then the
> clock framework will turn these clocks off during bootup.
>
> Explicitly request and keep this clock enabled at init for the
> Pandaboard, so that the PHY receives this clock at all times.
>
> Reported-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
> Tony,
>
> The clock database changes were merged just before Christmas, so
> we did not detect this sooner. Would be nice to get this merged in
> the -rc series, so that we get EHCI and ethernet functional on the Panda.
>
> Ming Lei,
>
> Could you please test this and confirm it fixes the issue for you?

Yes, the patch does fix the issue on my panda board even
CONFIG_OMAP_RESET_CLOCKS is enabled.

thanks,
-- 
Lei Ming
