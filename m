Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2G0Xcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:32:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39932 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2G0Xcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <1343184588-20239-1-git-send-email-ccross@android.com>
References: <1343184588-20239-1-git-send-email-ccross@android.com>
Date: Sat, 28 Jul 2012 01:32:50 +0200
Message-ID: <CACRpkdZv4p+QT3Y+=-xh5iJ=sr1_aahroxQ535QpzVD9e_ESJA@mail.gmail.com>
Subject: Re: [RFC v2] ARM: sched_clock: update epoch_cyc on resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org, Barry Song <21cnbao@gmail.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Krzysztof Halasa <khc@pm.waw.pl>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 4:49 AM, Colin Cross <ccross@android.com> wrote:

> Many clocks that are used to provide sched_clock will reset during
> suspend.  If read_sched_clock returns 0 after suspend, sched_clock will
> appear to jump forward.  This patch resets cd.epoch_cyc to the current
> value of read_sched_clock during resume, which causes sched_clock() just
> after suspend to return the same value as sched_clock() just before
> suspend.
>
> In addition, during the window where epoch_ns has been updated before
> suspend, but epoch_cyc has not been updated after suspend, it is unknown
> whether the clock has reset or not, and sched_clock() could return a
> bogus value.  Add a suspended flag, and return the pre-suspend epoch_ns
> value during this period.
>
> The new behavior is triggered by calling setup_sched_clock_needs_suspend
> instead of setup_sched_clock.
>
> Signed-off-by: Colin Cross <ccross@android.com>

Sweet!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
