Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1AJQ5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:57:12 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41551 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1AJQ5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:57:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x/dLBhyWzCCImHHaw8Wi8QE0nb5UtADuZa68A9pfwViYDndE4U5BVVkOEhuWFxJD+p
         Rv7PWyO/Bl4xIfGVie4ypZdKzqN6k65+7kJR/q/qjCan4stg0l6R3QWO9wecGcg/Xv1Q
         aNrS0QeyUXqIAQRTCo+w8ABwxvtqie8y1D8B8=
MIME-Version: 1.0
In-Reply-To: <ADE0108D-6DF1-4230-B7FB-39D7AC7F63D1@marvell.com>
References: <cover.1294588491.git.tardyp@gmail.com>
	<4663ceeebbd267abb11515570ac17702a6a482f4.1294588491.git.tardyp@gmail.com>
	<ADE0108D-6DF1-4230-B7FB-39D7AC7F63D1@marvell.com>
Date: Mon, 10 Jan 2011 17:57:07 +0100
Message-ID: <AANLkTimSV07Kdk_xq3nhGa26-SF_u3gxCM+CUhmRJrib@mail.gmail.com>
Subject: Re: [PATCH 2/3] mmc: add MMC_QUIRK_BROKEN_CLK_GATING
From: Pierre Tardy <tardyp@gmail.com>
To: Philip Rakity <prakity@marvell.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
> Since the code is not called that often could you change the above code to:
>
>>       if (mmc_card_sdio(card))
>>               return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);
Well, The comment in the
>        return true;
>
> more obvious that quirk only applies to sdio.

Disagree.Actually, before this code, there is a pretty long comment,
that explain that this quirk only apply to sdio.

If we figure out later that some sdcard does not like clock gating
either, we could add this quirk to those bad sdcard as well.

Here is the whole resulting function. I think this is clear enough:

static bool mmc_host_may_gate_card(struct mmc_card *card)
{

        /* If there is no card we may gate it */
        if (!card)
               return true;
        /*
        * Don't gate SDIO cards! These need to be clocked at all times
        * since they may be independent systems generating interrupts
        * and other events. The clock requests counter from the core will
        * go down to zero since the core does not need it, but we will not
        * gate the clock, because there is somebody out there that may still
        * be using it.
        */
        return !(card->quirks & MMC_QUIRK_BROKEN_CLK_GATING);


}
Pierre
