Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab2JVULw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:11:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54242 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JVULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:11:51 -0400
Message-ID: <5085A883.9010803@wwwdotorg.org>
Date: Mon, 22 Oct 2012 14:11:47 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@st.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: Re: [PATCH] pinctrl: reserve pins when states are activated
References: <1350893718-12336-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1350893718-12336-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 02:15 AM, Linus Walleij wrote:
> This switches the way that pins are reserved for multiplexing:
> 
> We used to do this when the map was parsed, at the creation of
> the settings inside the pinctrl handle, in pinmux_map_to_setting().
> 
> However this does not work for us, because we want to use the
> same set of pins with different devices at different times: the

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c

>  void pinmux_free_setting(struct pinctrl_setting const *setting)
...
> +	/* This function is currently unused */

Being picky: It's not unused; it is used by pinctrl_put_locked(), but
just doesn't have to do anything given the implementation of
pinmux_map_to_setting().
