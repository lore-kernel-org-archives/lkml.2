Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2JSMvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:51:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46008 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab2JSMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <508091C4.9080008@wwwdotorg.org>
References: <1350554487-7914-1-git-send-email-linus.walleij@stericsson.com>
	<508091C4.9080008@wwwdotorg.org>
Date: Fri, 19 Oct 2012 14:51:21 +0200
Message-ID: <CACRpkdbHLpkqGx4bGPxYN43QiQRedirRnf+tQ7avbQmd6k1kQQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: reserve pins when states are activated
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 1:33 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 10/18/2012 04:01 AM, Linus Walleij wrote:
>> This switches the way that pins are reserved for multiplexing:
>
> The conceptual change makes perfect sense to me.

Thanks...

>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>
>>  void pinmux_free_setting(struct pinctrl_setting const *setting)
> ...
>> +     /*
>> +      * If a setting is active, disable it so that all pins are released
>> +      */
>> +     pinmux_disable_setting(setting);
>
> "*If* a setting is active ..." implies there should be a C if statement
> here to check if the setting is actually active before trying to disable it?

Spot on.

Actually in core.c we're already checking this:

	case PIN_MAP_TYPE_MUX_GROUP:
		if (state == p->state)
			pinmux_disable_setting(setting);
		pinmux_free_setting(setting);
		break;

So this is just buggy driving the refcount down to negative.
(I think Jean-Nicolas noticed this phenomenon...)

I should just delete pinmux_free_setting().

Yours,
Linus Walleij

Yours,
Linus Walleij
