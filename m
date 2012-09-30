Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab2I3Ihp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 04:37:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55950 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2I3Ihk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 04:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFq=kF3n7kiFUhv+6KkVdi99G+0aHOFVNMLPRO60jpEoBg@mail.gmail.com>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
	<1348497799-32143-3-git-send-email-ulf.hansson@stericsson.com>
	<20120924153514.12878.47739@nucleus>
	<CAPDyKFqKUuqEj7yWGMPnFUvE2-kBExevweMdGAdD1EjhHSEwsQ@mail.gmail.com>
	<20120926192532.12878.56719@nucleus>
	<CAPDyKFq=kF3n7kiFUhv+6KkVdi99G+0aHOFVNMLPRO60jpEoBg@mail.gmail.com>
Date: Sun, 30 Sep 2012 10:37:39 +0200
Message-ID: <CACRpkdZHveqq-o48wd7+aLhG02sQTOu6myBX69FNRn8xEus+PQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] clk: ux500: Support prcmu ape opp voltage clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>,
        Ulf Hansson <ulf.hansson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 9:43 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:

> In my case for ux500 we use the mmci host driver. It is an ARM cross
> SoC device driver, and I believe adding clock notifiers in the driver
> to handle the voltage scale would complicate things quite a bit. It
> seems a lot easier to let the clock driver handle this, especially
> since the frequency will remain fixed after initialization. So in the
> end I see now need and benefit for adding the clock notifiers in the
> mmci host driver.

Right now it certainly cannot be done anyway, because some of the
clients to this driver does not implement the generic clock framework,
and thus it just won't compile anymore for them if we introduce that.

The patch does raise the issue of how to handle OPP requests
though.

Yours,
Linus Walleij
