Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab2JVGVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:21:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50855 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2JVGVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <20121022060641.GB3900@localhost.localdomain>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
	<20121022060641.GB3900@localhost.localdomain>
Date: Mon, 22 Oct 2012 11:51:11 +0530
Message-ID: <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: thierry.reding@avionic-design.de, Shiraz Hashim <shiraz.hashim@st.com>
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 October 2012 11:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> On Mon, Oct 22, 2012 at 09:39:21AM +0530, viresh kumar wrote:
>> On Mon, Oct 22, 2012 at 9:21 AM, Shiraz Hashim <shiraz.hashim@st.com> wrote:

>> > +static int spear_pwm_remove(struct platform_device *pdev)
>> > +{
>> > +       struct spear_pwm_chip *pc = platform_get_drvdata(pdev);
>> > +       int i;
>> > +
>> > +       for (i = 0; i < NUM_PWM; i++) {
>> > +               struct pwm_device *pwm = &pc->chip.pwms[i];
>> > +
>> > +               if (test_bit(PWMF_ENABLED, &pwm->flags)) {
>> > +                       spear_pwm_writel(pc, i, PWMCR, 0);
>> > +                       clk_disable(pc->clk);
>> > +               }
>> > +       }
>> > +
>> > +       /* clk was prepared in probe, hence unprepare it here */
>> > +       clk_unprepare(pc->clk);
>>
>> I believe you need to remove the chip first and then do above to
>> avoid any race conditions, that might occur.
>
> I am afraid, I would loose all chips and their related information
> (PWMF_ENABLED) then.

I have just checked core's code, and yes you are correct.
Now i have another doubt :)

Why shouldn't you do this instead:

       for (i = 0; i < NUM_PWM; i++)
              pwm_diable(&pc->chip.pwms[i]);

And, why should we put above code in pwmchip_remove() instead, so that
pwm drivers don't need to do all this?

@Thierry: Your inputs are required here :)

>> > +       return pwmchip_remove(&pc->chip);
>> > +}
>> > +
>>
>> After all this please add my:
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> I had already added your sob as you were the original author,
> should I add a separate acked-by also ?

Yes, it should be fine. I have seen that earlier.

Because you weren't the original author, you kept my SOB.
This Acked-by will guarantee that original author is okay with
the changes you have made. :)

--
viresh
