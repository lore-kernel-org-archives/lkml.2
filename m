Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3AJKvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:51:24 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:52805 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3AJKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:51:22 -0500
MIME-Version: 1.0
In-Reply-To: <1357163240-23131-1-git-send-email-linux@prisktech.co.nz>
References: <1357163240-23131-1-git-send-email-linux@prisktech.co.nz>
Date: Thu, 10 Jan 2013 11:51:22 +0100
Message-ID: <CACRpkdYwn0uc1Nk+RMcx_AaZ5o6k2ug1rAAJrJCGNb9J4MwWhw@mail.gmail.com>
Subject: Re: [PATCH] gpio: vt8500: memory cleanup missing
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 10:47 PM, Tony Prisk <linux@prisktech.co.nz> wrote:

> This driver is missing a .remove callback, and the fail path on
> probe is incomplete.
>
> If an error occurs in vt8500_add_chips, gpio_base is not unmapped.
> The driver is also ignoring the return value from this function so
> if a chip fails to register it completes as successful.
>
> Replaced pr_err with dev_err in vt8500_add_chips since the device is
> available.
>
> There is also no .remove callback defined. To allow removing the
> registered chips, I have moved *vtchip to be a static global.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>

Applied to fixes, thanks!

Yours,
Linus Walleij
