Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1CFMGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:06:40 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55487 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1CFMGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:06:37 -0500
MIME-Version: 1.0
In-Reply-To: <eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
References: <1290060899-9786-1-git-send-email-ccross@android.com>
	<AANLkTimCuV5N0jr8c949uONEvieQ5MDZ9KHDXtneG5AT@mail.gmail.com>
	<4D70BE9D.4000507@stericsson.com>
	<AANLkTin7ZXYALOy_jk1uR3SbZA51nSnU-ncSjG+n_RPn@mail.gmail.com>
	<4D714C17.7080102@gmail.com>
	<AANLkTims4e7o0sPxVnN0D1mNWDH7uC9q=pBQrBoad2os@mail.gmail.com>
	<eea425c066cc69c30f118fb102fff43e@mail.gmail.com>
Date: Sun, 6 Mar 2011 13:06:36 +0100
Message-ID: <AANLkTi=KcmqmghVxhwGvv79heRU3C+TC-v2VnWSWt7bU@mail.gmail.com>
Subject: Re: [PATCH] ARM: twd: Adjust localtimer frequency with cpufreqnotifiers
From: Linus Walleij <linus.walleij@linaro.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Colin Cross <ccross@android.com>, Rob Herring <robherring2@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Varun Swara <Varun.Swara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        martin persson <martin.persson@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 9:19 AM, Santosh Shilimkar
<santosh.shilimkar@ti.com> wrote:

> While doing this patch for OMAP I also found that
> CPUFREQ notifiers does delays scaling timer frequency
> and there is a tick deviation(3-4 ms) around 1st tick and
> last tick around twd rescaling.

Is this caused by ticks that have been programmed
already (based on the previous frequency) when the scaling
takes effect? (That's most likely I think.)

The latter could be fixed by simply calling
schedule() for each CPU connected in the same core as
the TWD at the end of twd_update_cpu_frequency(),
couldn't it?

Colin what do you say?

> Another issue was not able to select higher fixed twd rate
> and found fix for the same.

Can you send out the patch?

Yours,
Linus Walleij
