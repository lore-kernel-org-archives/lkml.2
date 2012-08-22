Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab2HVQBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:01:06 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:58620 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710Ab2HVQBB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:01:01 -0400
From: Philip Rakity <prakity@marvell.com>
To: Doug Anderson <dianders@chromium.org>
CC: Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 22 Aug 2012 09:00:43 -0700
Subject: Re: [PATCH 1/2] mmc: core: Add a capability for disabling mmc cards
Thread-Topic: [PATCH 1/2] mmc: core: Add a capability for disabling mmc cards
Thread-Index: Ac2Af0kY4pNx+8hDTeOFeh5YtSaoWw==
Message-ID: <5ED03810-753A-407D-A994-E1FD22BE45E6@marvell.com>
References: <1345608318-15347-1-git-send-email-dianders@chromium.org>
 <50346181.3010406@samsung.com>
 <CAD=FV=UZM9b6++DkgemZA7qpAZgFN+NyyLjRecgSdjcEsu0YYA@mail.gmail.com>
In-Reply-To: <CAD=FV=UZM9b6++DkgemZA7qpAZgFN+NyyLjRecgSdjcEsu0YYA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 22, 2012, at 8:44 AM, Doug Anderson <dianders@chromium.org> wrote:

> Jaehoon,
> 
> On Tue, Aug 21, 2012 at 9:35 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> 
>> Hi Doug,
>> 
>> I didn't know what purpose is.
>> Why need to add the MMC_CAP2_NO_MMC?
>> If card is SD or SDIO, mmc_attach_mmc(host) should not be entered.
>> Could you explain to me in more detail?
> 
> Thanks for your feedback.  In this case I have a card that is an MMC
> card so mmc_attach_sdio() and mmc_attach_sd() will fail.  If I let
> mmc_attach_mmc() run it will actually find the MMC card.  However, on
> this platform it is not valid to recognize MMC cards.
> 


Understand.   

Can you explain why the change is needed.  Is it for technical 
reasons that MMC is not allowed -- if so then I do not understand how SD can work
and MMC cannot.

If it is for marketing reasons -- then --- oh well .....


Could you add some additional comments to the commit message.
I think it makes sense to handle all 3 cases
a) SDIO not allowed
b) SD not allowed
c) MMC not allowed

> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

