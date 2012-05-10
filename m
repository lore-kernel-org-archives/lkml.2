Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab2EJMQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:16:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab2EJMQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1336644082-14137-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 10 May 2012 14:16:56 +0200
Message-ID: <CACRpkdbA58UiNLZRPWe1yGckGFrXqtJ3ddqjLLzLntC6+Cin3g@mail.gmail.com>
Subject: Re: [PATCH] gpio/langwell: re-read the IRQ status register after each iteration
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, Julia Lawall <Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 12:01 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> Spotted by Grant Likely. The IRQ status register should be re-read after
> each iteration. Otherwise the loop misses the interrupt if it gets raised
> immediately after handled.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> This patch applies on top of my previous patch ("gpio: langwell: convert to
> use irq_domain").

Oh yeah that thing I recognize!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

If someone has  time I think it would be a good idea to
conjure a cocienelle sematic patch to catch this pattern, because
I suspect it might exist in more IRQ handlers.

-               pending = readl(gedr);
-               while (pending) {
+               while ((pending = readl(gedr))) {
                       gpio = __ffs(pending);
                       mask = BIT(gpio);
-                       pending &= ~mask;

Yours,
Linus Walleij
