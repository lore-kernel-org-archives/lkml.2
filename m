Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2JSJpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:45:36 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54594 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2JSJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:45:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121019094308.GC4185@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mdtkW=a-xv1BeHxoGsgbF5s+4B8QmZBdvqnWHr30Ap2A@mail.gmail.com>
	<20121019055943.GA4185@localhost.localdomain>
	<CAOh2x=kXu2EG4GFaW8HpSi=VFLvGEMEyeN_3L74wU2sfe1Z=uQ@mail.gmail.com>
	<20121019094308.GC4185@localhost.localdomain>
Date: Fri, 19 Oct 2012 15:15:34 +0530
Message-ID: <CAKohpon3krdFCK-vE-XemOS4drxA3V+dfc7e4qLyf+hGywbj-w@mail.gmail.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, spear--sw-devel@lists.codex.cro.st.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2012 15:13, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> It may not be required as pwms which are not enabled do not have
> their clocks enabled. Hence, perhaps we can do following,
>
> 8<---------------------------
> static int spear_pwm_remove(struct platform_device *pdev)
> {
>         struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
>         int i;
>
>         if (WARN_ON(!pc))
>                 return -ENODEV;
>
>         for (i = 0; i < NUM_PWM; i++) {
>                 struct pwm_device *pwm = &pc->chip.pwms[i];
>
>                 if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>                         spear_pwm_writel(pc, i, PWMCR, 0);
>                         clk_disable(pc->clk);
>                 }
>         }
>
>         /* clk was prepared in probe, hence unprepare it here */
>         clk_unprepare(pc->clk);
>         return pwmchip_remove(&pc->chip);
> }

Better.
