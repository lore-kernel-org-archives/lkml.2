Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab2KDSML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:12:11 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53013 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab2KDSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:12:09 -0500
MIME-Version: 1.0
In-Reply-To: <1351779602-13818-3-git-send-email-ulf.hansson@stericsson.com>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
	<1351779602-13818-3-git-send-email-ulf.hansson@stericsson.com>
Date: Sun, 4 Nov 2012 19:12:07 +0100
Message-ID: <CACRpkdbZB4nhFQtLH-GxBSK99RFk7yhSYMhO5keVjyugrqr7JA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: nomadik-ske-keypad - start using the apb_pclk
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 3:20 PM, Ulf Hansson <ulf.hansson@stericsson.com> wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> Previously this clock was handled internally by the clockdriver,
> but now this is separate clk. So we need take care of it.
>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

So this is a silicon block clock and falls into the category of things
we've been discussing...

If I understand correctly, the only "real" solution is to
implement the PM domains and have these enable the clocks.

An alternative may be to move this driver over to the AMBA bus,
because I think this device actually has primecell registers.
Then the bus will take care of the pclk for starters.

Yours,
Linus Walleij
