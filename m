Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2IRLu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:50:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33585 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab2IRLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:50:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x==GY6xvyWmLJtpR68x1kiFWO8F85RwS6VfHjJA8YdhgvA@mail.gmail.com>
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
	<CACRpkdbHegZAw+9XXzOb5UPPqJvzoNfPJ5aPDhuwWWhWunuv8w@mail.gmail.com>
	<CAOh2x==GY6xvyWmLJtpR68x1kiFWO8F85RwS6VfHjJA8YdhgvA@mail.gmail.com>
Date: Tue, 18 Sep 2012 13:50:56 +0200
Message-ID: <CACRpkdYnW=VbR1ieF1oicdPF79jV2raX9xkccE_ndrxQQjkUqw@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add clk_{un}prepare() support in runtime PM
From: Linus Walleij <linus.walleij@linaro.org>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vipul Kumar Samar <vipulkumar.samar@st.com>, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 6:09 AM, viresh kumar <viresh.kumar@linaro.org> wrote:

> Yes, we don't need to call prepare() again atleast for SPEAr. You are correct.
> I saw the driver after a long time :)

I'm asking because it's actually OK to do this, I was more asking whether it
was really needed by any platforms...

> Can you please elaborate, why can't i see any clk_disable/enable calls anywhere
> else from probe. If i remember correctly, earlier we used to enable/disable
> clk after transfers and also during suspend/resume.

We clk_disable() at runtime_suspend() and clk_enable() at runtime resume,
and the driver gives hints to the runtime PM layer to autosuspend the
driver whenever it's unused. Check the pm_runtime_* calls.

> The amba layer is taking care of interface clock only and not
> functional clock. So
> i believe that's not the magic code. :)

This clock is the one for the external bus. In some designs these two
clocks are one and the same, and these won't currently get into any clock
disabled states, sadly. (We need to fix that some day.)

Yours,
Linus Walleij
