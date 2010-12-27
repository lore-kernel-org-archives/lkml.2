Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab0L0V1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 16:27:23 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64478 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0L0V1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 16:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=blYAtY39Aqn3kBktcShAhXBxrxudUfli7SBuaXgsmhzMq+9ARktGzuFrS/7kgAa4Jx
         W2pKHBbeK7wjEQUqoMJn2CC3sIsQ1m+T6dMsGrABWjHOadOGeHXihUwB9PDXUIo24fKq
         TkalevsAldn+ECvpWm350uIc5F7rZbCEEI5UU=
MIME-Version: 1.0
In-Reply-To: <00d601cba465$27154a70$753fdf50$@mprc.pku.edu.cn>
References: <00d601cba465$27154a70$753fdf50$@mprc.pku.edu.cn>
Date: Mon, 27 Dec 2010 13:27:20 -0800
X-Google-Sender-Auth: napXvz9quWtT-YuAO59NvETWHRw
Message-ID: <AANLkTinjzzMz4WFRYmjZiM=P6c1wtSxpY2bzOuUe0Vrd@mail.gmail.com>
Subject: Re: [PATCHv1 09/12] unicore32 core architecture: timer and time
From: john stultz <johnstul@us.ibm.com>
To: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/25 Guan Xuetao <guanxuetao@mprc.pku.edu.cn>:
> From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
>
> Patch 9 implements timer and time. RTC and PWM device drivers are also here.
>
> Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Just a small request:

> +static struct clocksource cksrc_puv3_oscr = {
> +       .name           = "oscr",
> +       .rating         = 200,
> +       .read           = puv3_read_oscr,
> +       .mask           = CLOCKSOURCE_MASK(32),
> +       .shift          = 18,

Drop the shift assignment here.

> +       cksrc_puv3_oscr.mult =
> +               clocksource_hz2mult(CLOCK_TICK_RATE, cksrc_puv3_oscr.shift);
> +
Drop the mult assignment here.


> +       clocksource_register(&cksrc_puv3_oscr);

Use "clocksource_register_hz(&cksrc_puv3_oscr, CLOCK_TICK_RATE );" and
the kernel will fill in mult/shift appropriately.

If you have any troubles after doing so, let me know.

thanks
-john
