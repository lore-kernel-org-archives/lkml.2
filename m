Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2DXNmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:42:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48278 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab2DXNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:42:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120424120019.GE24089@lunn.ch>
References: <cover.1335266056.git.viresh.kumar@st.com>
	<abbcf661dc58948794839eb0fba1d5a0950ec848.1335266056.git.viresh.kumar@st.com>
	<20120424120019.GE24089@lunn.ch>
Date: Tue, 24 Apr 2012 19:12:10 +0530
Message-ID: <CAOh2x==YaPxYxigyE=n2weoKHhu4ktGRHHGdzgs2+d1_Lo-D4Q@mail.gmail.com>
Subject: Re: [PATCH V3 07/12] ata/sata_mv: Remove conditional compilation of
 clk code
From: viresh kumar <viresh.linux@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Viresh Kumar <viresh.kumar@st.com>, akpm@linux-foundation.org,
        spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        linux@arm.linux.org.uk, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/12, Andrew Lunn <andrew@lunn.ch> wrote:
> Sorry, but still wrong.
>
> The clock is optional. If we can find a clock, turn it on. If not,
> keep going....
>
> You patch causes the missing clock to become a fatal error.
>
> This sata_mv exists in multiple forms. It can be part of a SoC. It can
> also be on a PCI bus. In the PCI form, it is unlikely to have a clk
> which can be controlled. When built into a SoC, namely one of the
> Orion family, dove, orion5x, mv78xx0 do not have a clock which can be
> controlled. However kirkwood does have a clock.
>
> So, kirkwood will provide a clock and expects that sata_mv will turn
> it on. All the other ways of using sata_mv will not provide a clock,
> but still expect the driver to be happy.

Hmm. What this code does now is:
If HAVE_CLK is selected, then there must be a clock for the device. Otherwise
it will always pass.

You want not to return error if a platform does have HAVE_CLK, but doesn't
have a clock for sata? That would be simple to fix, but want to confirm if this
is actually required.

@Russell: Can we have your view also?

--
viresh
