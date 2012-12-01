Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2LARQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 12:16:37 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:54681 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab2LARQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 12:16:36 -0500
MIME-Version: 1.0
In-Reply-To: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
References: <1354103571-27394-1-git-send-email-rabin.vincent@stericsson.com>
Date: Sat, 1 Dec 2012 18:16:34 +0100
Message-ID: <CACRpkdbq02xnVJ4tnZvOFsp8JuP6-F0KLKyyv9TgyY9dWSdDJg@mail.gmail.com>
Subject: Re: [RFC 1/2] clk: use struct clk only for external API
From: Linus Walleij <linus.walleij@linaro.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Turquette <mturquette@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 12:52 PM, Rabin Vincent
<rabin.vincent@stericsson.com> wrote:

> In order to provide per-user accounting, this separates the struct clk
> used in the common clock framework into two structures 'struct clk_core'
> and 'struct clk'.  struct clk_core will be used for internal
> manipulation and struct clk will be used in the clock API
> implementation.
>
> In this patch, struct clk is simply renamed to struct clk_core and a new
> struct clk is implemented which simply wraps it.  In the next patch, the
> new struct clk will be used to implement per-user clock enable
> accounting.
>
> There is a rather hacky #define of clk_core to clk for the non-common
> clk case in order to avoid a mass rename of all clk non-common clk
> implementations.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>

I like the spirit of this and I think it was Thomas Gleixner who early
on strongly recommended that the struct be kept as private as possible.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
