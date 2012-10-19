Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab2JSQSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:18:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46729 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2JSQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:18:51 -0400
Message-ID: <50817D67.10900@wwwdotorg.org>
Date: Fri, 19 Oct 2012 10:18:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: [PATCH v2] pinctrl: reserve pins when states are activated
References: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1350651909-5337-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 07:05 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This switches the way that pins are reserved for multiplexing:
> 
> We used to do this when the map was parsed, at the creation of
> the settings inside the pinctrl handle, in pinmux_map_to_setting().
> 
> However this does not work for us, because we want to use the
> same set of pins with different devices at different times: the

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> @@ -689,7 +691,6 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
>  			case PIN_MAP_TYPE_MUX_GROUP:
>  				if (state == p->state)
>  					pinmux_disable_setting(setting);
> -				pinmux_free_setting(setting);

Personally, I would keep that function, and just remove the body. I
believe that even though it currently doesn't have to do anything, it
provides documentation for where any required cleanup would be placed if
needed in the future.

If you still want to remove the function, pinconf_free_setting() should
also be removed, since that's empty right now.

Irrespective,

Acked-by: Stephen Warren <swarren@nvidia.com>
