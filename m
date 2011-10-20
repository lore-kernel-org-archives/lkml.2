Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1JTJs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:48:58 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63369 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab1JTJs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1319062768-26391-4-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
	<1319062768-26391-4-git-send-email-swarren@nvidia.com>
Date: Thu, 20 Oct 2011 11:48:56 +0200
Message-ID: <CACRpkdae_DWEMQc+NOT1oX4XXKFzjXg3uiHihXMHr+ztPPAQdg@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: Don't copy function name when requesting a pin
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 12:19 AM, Stephen Warren <swarren@nvidia.com> wrote:

> Instead, store a pointer to the currently assigned function.
>
> This allows us to delete the mux_requested variable from pin_desc; a pin
> is requested if its currently assigned function is non-NULL.
>
> When a pin is requested as a GPIO rather than a regular function, the
> assigned function name is dynamically constructed. In this case, we have
> to kstrdup() the dynamically constructed name, so that mux_function doesn't
> pointed at stack data. This requires pin_free to be told whether to free
> the mux_function pointer or not.
>
> This removes the hard-coded maximum function name length.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks, applied.
Linus Walleij
