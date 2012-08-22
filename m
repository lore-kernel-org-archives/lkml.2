Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775Ab2HVQum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:50:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57928 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2HVQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:50:39 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:cca8:bab3:6221:a45f]
In-Reply-To: <5ED03810-753A-407D-A994-E1FD22BE45E6@marvell.com>
References: <1345608318-15347-1-git-send-email-dianders@chromium.org>
	<50346181.3010406@samsung.com>
	<CAD=FV=UZM9b6++DkgemZA7qpAZgFN+NyyLjRecgSdjcEsu0YYA@mail.gmail.com>
	<5ED03810-753A-407D-A994-E1FD22BE45E6@marvell.com>
Date: Wed, 22 Aug 2012 09:50:37 -0700
Message-ID: <CAOesGMjX+jW6PKCzej27NHN2QFTg8XbMawPJNa53eQ2ojee3+A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: Add a capability for disabling mmc cards
From: Olof Johansson <olof@lixom.net>
To: Philip Rakity <prakity@marvell.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Chris Ball <cjb@laptop.org>,
        Will Newton <will.newton@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 22, 2012 at 9:00 AM, Philip Rakity <prakity@marvell.com> wrote:
>
> On Aug 22, 2012, at 8:44 AM, Doug Anderson <dianders@chromium.org> wrote:
>
>> Jaehoon,
>>
>> On Tue, Aug 21, 2012 at 9:35 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>>>
>>> Hi Doug,
>>>
>>> I didn't know what purpose is.
>>> Why need to add the MMC_CAP2_NO_MMC?
>>> If card is SD or SDIO, mmc_attach_mmc(host) should not be entered.
>>> Could you explain to me in more detail?
>>
>> Thanks for your feedback.  In this case I have a card that is an MMC
>> card so mmc_attach_sdio() and mmc_attach_sd() will fail.  If I let
>> mmc_attach_mmc() run it will actually find the MMC card.  However, on
>> this platform it is not valid to recognize MMC cards.
>>
>
>
> Understand.
>
> Can you explain why the change is needed.  Is it for technical
> reasons that MMC is not allowed -- if so then I do not understand how SD can work
> and MMC cannot.
>
> If it is for marketing reasons -- then --- oh well .....
>
>
> Could you add some additional comments to the commit message.
> I think it makes sense to handle all 3 cases
> a) SDIO not allowed
> b) SD not allowed
> c) MMC not allowed

We are working with a system manufacturer who wishes to only support
SD cards in their product, and need to accommodate that. It made sense
for us to contribute this work upstream since others might want to do
the same in the future for some reason.

Adding all three cases makes sense if others foresee a use case for it.


-Olof
