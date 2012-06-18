Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2FRM15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:27:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57745 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRM14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:27:56 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZzj2J8UY30Ee+XEtf2NarJJzVzzHCWkucptUuQb3L_ww@mail.gmail.com>
References: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
	<1339946252-21019-2-git-send-email-otavio@ossystems.com.br>
	<CACRpkdZzj2J8UY30Ee+XEtf2NarJJzVzzHCWkucptUuQb3L_ww@mail.gmail.com>
Date: Mon, 18 Jun 2012 17:57:55 +0530
Message-ID: <CAHdPZaNBPLZgpSXzgNXt+D6cJdaD_1vo0Wbyah4UKNj6UfKHXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-mxs: fix implicit declaration of free()
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Fabio Estevam <festevam@gmail.com>, fabio.estevam@freescale.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 18, 2012 at 11:34 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> But:
>
>>  free_group:
>> -       if (!purecfg)
>> -               free(group);
>> +       kfree(group);
>
> Why did you delete the if (!purecfg) clause?
>
One way we can say that as kfreeing of null doesn't affect (panic)
anything and using it
without purecfg may be ok.

but as the code flow says that the group is allocated only when the
purecfg is not true, so i think
its better to follow that way.

> Yours,
> Linus Walleij

Thanks,
Devendra.
