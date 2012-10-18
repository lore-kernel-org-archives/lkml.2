Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2JRXd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:33:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36109 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JRXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:33:28 -0400
Message-ID: <508091C4.9080008@wwwdotorg.org>
Date: Thu, 18 Oct 2012 17:33:24 -0600
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
Subject: Re: [PATCH] pinctrl: reserve pins when states are activated
References: <1350554487-7914-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1350554487-7914-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 04:01 AM, Linus Walleij wrote:
> This switches the way that pins are reserved for multiplexing:

The conceptual change makes perfect sense to me.

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c

>  void pinmux_free_setting(struct pinctrl_setting const *setting)
...
> +	/*
> +	 * If a setting is active, disable it so that all pins are released
> +	 */
> +	pinmux_disable_setting(setting);

"*If* a setting is active ..." implies there should be a C if statement
here to check if the setting is actually active before trying to disable it?
