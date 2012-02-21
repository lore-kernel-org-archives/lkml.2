Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2BUN67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 08:58:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46368 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2BUN66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 08:58:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.169.9 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <1329720360-23227-14-git-send-email-swarren@nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
	<1329720360-23227-14-git-send-email-swarren@nvidia.com>
Date: Tue, 21 Feb 2012 14:58:57 +0100
Message-ID: <CACRpkdaEVSxpR3z93_bfG28_vj4i5z9Zpne4XUhvTz7fvkXypg@mail.gmail.com>
Subject: Re: [PATCH 13/20] pinctrl: Error if mapping table's control dev can't
 be found
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

> This is a serious error, and the pin control system will not function
> correctly if it ends up not programing the mapping table entries into
> the HW. Instead of just ignoring this, error out.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Thanks applied, this came to bite me today so I see the value
of being strict here.

> +                       /* Eventually, this should trigger deferred probe */
> +                       return -ENODEV;

I changed this to ERR_PTR(-ENODEV) in my codebase as
it returns a pointer.

Yours,
Linus Walleij
