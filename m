Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2LKVLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 16:11:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56304 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab2LKVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 16:11:52 -0500
Message-ID: <50C7A194.7070102@wwwdotorg.org>
Date: Tue, 11 Dec 2012 14:11:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Julien Delacou <julien.delacou@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] pinctrl: add sleep mode management for hogs
References: <1355234393-17368-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1355234393-17368-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 06:59 AM, Linus Walleij wrote:
> From: Julien Delacou <julien.delacou@stericsson.com>
> 
> This fix allows handling sleep mode for hogged
> pins in pinctrl. It provides functions to set pins
> to sleep/default configurations according to their
> current state from the individual pinctrl drivers.

> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h

> +extern int pinctrl_force_sleep(struct pinctrl_dev *pctldev);
> +extern int pinctrl_force_default(struct pinctrl_dev *pctldev);

Since I assume those function are only supposed to be used by pinctrl
drivers themselves, should the prototypes go into drivers/pinctrl/core.h
or similar, rather than something in include/linux/pinctrl?

Oh, and don't you need EXPORT_SYMBOL in case the pinctrl driver is a module?

Aside from that,

Reviewed-by: Stephen Warren <swarren@nvidia.com>

