Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2IREJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 00:09:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52668 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2IREJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 00:09:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbHegZAw+9XXzOb5UPPqJvzoNfPJ5aPDhuwWWhWunuv8w@mail.gmail.com>
References: <1f784b72399e0e96414f00866b209e2e218065af.1347877746.git.vipulkumar.samar@st.com>
	<CACRpkdbHegZAw+9XXzOb5UPPqJvzoNfPJ5aPDhuwWWhWunuv8w@mail.gmail.com>
Date: Tue, 18 Sep 2012 09:39:09 +0530
X-Google-Sender-Auth: 0NLe6-KLSlQno1yqgxr85dRLwEs
Message-ID: <CAOh2x==GY6xvyWmLJtpR68x1kiFWO8F85RwS6VfHjJA8YdhgvA@mail.gmail.com>
Subject: Re: [PATCH] spi: pl022: Add clk_{un}prepare() support in runtime PM
From: viresh kumar <viresh.kumar@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vipul Kumar Samar <vipulkumar.samar@st.com>, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 7:09 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> This driver does clk_prepare/unprepare at probe
> and removed, so I guess what you're trying to say is that
> on your platform the clk_unprepare() process context call
> is needed to save power?
>
> Please elaborate...

Hi Linus,

Yes, we don't need to call prepare() again atleast for SPEAr. You are correct.
I saw the driver after a long time :)
Can you please elaborate, why can't i see any clk_disable/enable calls anywhere
else from probe. If i remember correctly, earlier we used to enable/disable
clk after transfers and also during suspend/resume.

The amba layer is taking care of interface clock only and not
functional clock. So
i believe that's not the magic code. :)

--
viresh
