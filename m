Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1BJIho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 03:37:44 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39892 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab1BJIhn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 03:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PGhigHWmfgCr4RIl3d8t6MiE3eU55HvYRAISfDVf8L/5PQEPip4denmbFTWRt7/uvr
         VplUok5dXcc3R7shzbddg8zrAvwVFfLUnEeofm1IfdtvXq9m5DG7JcZ8KqCXaWDybm+b
         TlRstuiWL1TiS11yPUkSn8OxvzG/oNjkRlAjg=
MIME-Version: 1.0
In-Reply-To: <20110206.111705.183051866.davem@davemloft.net>
References: <1296989469-7844-1-git-send-email-geert@linux-m68k.org>
	<1296989469-7844-5-git-send-email-geert@linux-m68k.org>
	<20110206.111705.183051866.davem@davemloft.net>
Date: Thu, 10 Feb 2011 09:37:41 +0100
X-Google-Sender-Auth: xEUmAOp61VtU2HcJj5kcQ572J6k
Message-ID: <AANLkTi=j7X0LShJs6EVt0c_uE3vUvZ9EdGLwv7i43vx+@mail.gmail.com>
Subject: Re: [PATCH 4/4] m68k/atari: ARAnyM - Add support for network access
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        aranym@lists.bobek.cz, schmitz@opal.biophys.uni-duesseldorf.de,
        pstehlik@sophics.cz, milan.jurik@xylab.cz, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 6, 2011 at 20:17, David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Sun,  6 Feb 2011 11:51:09 +0100
>
>> +     dev->trans_start = jiffies;
>
> Device drivers no longer make this operation, the generic code
> does it (see net/core/dev.c:dev_hard_start_xmit() and how it
> invokes txq_trans_update() on ->ndo_start_xmit() success).
>
> Therefore, please remove this line.

Will do.

(180 more to go in drivers/net/?)

>> +     pr_debug(DRV_NAME ": send %d bytes\n", len);
>
> For consistency with other network drivers, add an appropriate CPP
> define for "pr_fmt" and use netdev_info(), netdev_debug(), etc.
>
> In situations where a netdev pointer is not available
> (ie. pre-register_netdev()), use "dev_*()" instead.

Will fix.

Thanks for reviewing!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
