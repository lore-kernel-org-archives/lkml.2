Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2KWT5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:57:14 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46612 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KWT5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:57:11 -0500
Date: Fri, 23 Nov 2012 20:57:02 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: fix wrong delay sampling rate
Message-ID: <20121123195700.GA29269@balto.lan>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353676358-4385-1-git-send-email-fabio.baltieri@linaro.org>
 <CAKohpommGWb0WRnUDd_Do4yuadA5RcR4_ULFEqt+t9DNFnCg-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpommGWb0WRnUDd_Do4yuadA5RcR4_ULFEqt+t9DNFnCg-Q@mail.gmail.com>
X-Operating-System: Linux balto 3.7.0-rc2-00232-g6b8294a x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 07:23:28PM +0530, Viresh Kumar wrote:
> On 23 November 2012 18:42, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > Restore the correct delay value for ondemand's od_dbs_timer, as it was
> > changed erroneously in 83f0e55.
> >
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >  drivers/cpufreq/cpufreq_ondemand.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index bdaab92..cca3e9f 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -234,7 +234,8 @@ static void od_dbs_timer(struct work_struct *work)
> >                         dbs_info->sample_type = OD_SUB_SAMPLE;
> >                         delay = dbs_info->freq_hi_jiffies;
> >                 } else {
> > -                       delay = delay_for_sampling_rate(dbs_info->rate_mult);
> > +                       delay = delay_for_sampling_rate(od_tuners.sampling_rate
> > +                                               * dbs_info->rate_mult);
> 
> So sorry for my poor code :(

Actually I think that the new code is much better structured, and the
patch was so big that I'll be surprised if this would be the only bug!

My problem is that I had to rewrite a patch based on the old code almost
line-by-line but... these are the rules of the game!

> Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks,
Fabio

-- 
Fabio Baltieri
