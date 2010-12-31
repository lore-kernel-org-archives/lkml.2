Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0LaTSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 14:18:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47224
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754267Ab0LaTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 14:18:44 -0500
Date: Fri, 31 Dec 2010 11:19:15 -0800 (PST)
Message-Id: <20101231.111915.179940096.davem@davemloft.net>
To: jj@chaosbits.net
Cc: isdn@linux-pingi.de, julia@diku.dk, tj@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jolly@eversberg.eu
Subject: Re: [PATCH] ISDN cmx: Avoid potential NULL deref in
 dsp_cmx_send_member() and shrink code size.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1012182322330.17400@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012182322330.17400@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 18 Dec 2010 23:33:40 +0100 (CET)

> Hi there,
> 
> In drivers/isdn/mISDN/dsp_cmx.c::dsp_cmx_send_member() we currently have 
> this code:
> 
>            if (dsp->conf && dsp->conf->software && dsp->conf->hardware)
>                    tx_data_only = 1;
>            if (dsp->conf->software && dsp->echo.hardware)
>                    tx_data_only = 1;
> 
> The first line implies that 'dsp->conf' may be NULL. If it is, then the 
> third line will dereference a NULL pointer.
> 
> This patch reworks the code so that we avoid the potential NULL deref.
> It also has the added benefit that the object file size shrinks a bit.
> 
> before:
>    text    data     bss     dec     hex filename
>   18840     112    5784   24736    60a0 drivers/isdn/mISDN/dsp_cmx.o
> after:
>    text    data     bss     dec     hex filename
>   18816     112    5776   24704    6080 drivers/isdn/mISDN/dsp_cmx.o
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied.
