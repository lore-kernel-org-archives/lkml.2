Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2BTVIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:08:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36753 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab2BTVIA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:08:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.42.155.5 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-4-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-4-git-send-email-swarren@nvidia.com>
Date: Mon, 20 Feb 2012 22:08:00 +0100
Message-ID: <CACRpkdbejNdOOZVKTRZRSegoyydhWFaJX-ahL1zy5J8O+RNDkA@mail.gmail.com>
Subject: Re: [PATCH 03/20] pinctrl: Store mapping table as a list of chunks
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:45 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Instead of storing a single array of mapping table entries, which
> requires realloc()ing that array each time it's extended and copying
> the new data, simply store a list of pointers to the individual chunks.
> This also removes the need to copy the mapping table at all; a pointer
> is maintained to the original table, this saving memory.
>
> A macro for_each_maps() is introduced to hide the additional complexity
> of iterating over the map entries.
>
> This change will also simplify removing chunks of entries from the mapping
> table. This isn't important right now, but will be in the future, when
> mapping table entries are dynamically added when parsing them from the
> device tree, and removed when drivers no longer need to interact with
> pinctrl.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v2: Fixed kzalloc size parameter in pinctrl_register_mappings(),
>    add pr_error on kzalloc() failure, keep pinctrl_get() docs with
>    pinctrl_get() not pinctrl_get_locked(), make pinctrl_get_locked()
>    static, use list_add_tail instead of list_add, continue to duplicate
>    mapping table, don't remove __initdata from u300 mapping table.

Brilliant, applied.
Also tested on U300 up to this point, everything works just fine.

Thanks,
Linus Walleij
