Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab1GaFdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 01:33:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55541 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1GaFdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 01:33:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2Mp0Xs3ivj0Vd1=Euj1CyKsWpBLrf_L_jYWuOnoRMpxGGQ@mail.gmail.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
	<CAKnu2Mp0Xs3ivj0Vd1=Euj1CyKsWpBLrf_L_jYWuOnoRMpxGGQ@mail.gmail.com>
Date: Sat, 30 Jul 2011 22:33:05 -0700
Message-ID: <CAOh2x=ntfuZ46nGVAGgEeYNPQwV677sT2Bks7Ve02LZqthHpQA@mail.gmail.com>
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case of
 error interrupt
From: viresh kumar <viresh.linux@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, vinod.koul@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/11, Linus Walleij <linus.walleij@linaro.org> wrote:
> 2011/7/29 Viresh Kumar <viresh.kumar@st.com>:
> NAK.
>
> These snippets illustrate what is not good about this patch, you're making
> the driver fragile by removing checks for spurious IRQ.
>
> So for example if there is an error or TC IRQ on a channel that is not
> in use, what happens now?
>
> It used to result in IRQ_NONE, now all of a sudden we start handling
> spurious IRQs and claim IRQ_HANDLED with totally unpredictable
> results, whereas they would previously gather error metrics for
> spurious IRQs.
>

I got your point. Will resend this patch with better handling for
spurious interrupts.

--
viresh
