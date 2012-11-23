Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2KWUbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:31:55 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab2KWUby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:31:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: ondemand: fix wrong delay sampling rate
Date: Fri, 23 Nov 2012 21:36:25 +0100
Message-ID: <2571565.iEnLnHRzpM@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121123195700.GA29269@balto.lan>
References: <1353676358-4385-1-git-send-email-fabio.baltieri@linaro.org> <CAKohpommGWb0WRnUDd_Do4yuadA5RcR4_ULFEqt+t9DNFnCg-Q@mail.gmail.com> <20121123195700.GA29269@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 23, 2012 08:57:02 PM Fabio Baltieri wrote:
> On Fri, Nov 23, 2012 at 07:23:28PM +0530, Viresh Kumar wrote:
> > On 23 November 2012 18:42, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> > > Restore the correct delay value for ondemand's od_dbs_timer, as it was
> > > changed erroneously in 83f0e55.
> > >
> > > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > ---
> > >  drivers/cpufreq/cpufreq_ondemand.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > > index bdaab92..cca3e9f 100644
> > > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > > @@ -234,7 +234,8 @@ static void od_dbs_timer(struct work_struct *work)
> > >                         dbs_info->sample_type = OD_SUB_SAMPLE;
> > >                         delay = dbs_info->freq_hi_jiffies;
> > >                 } else {
> > > -                       delay = delay_for_sampling_rate(dbs_info->rate_mult);
> > > +                       delay = delay_for_sampling_rate(od_tuners.sampling_rate
> > > +                                               * dbs_info->rate_mult);
> > 
> > So sorry for my poor code :(
> 
> Actually I think that the new code is much better structured, and the
> patch was so big that I'll be surprised if this would be the only bug!
> 
> My problem is that I had to rewrite a patch based on the old code almost
> line-by-line but... these are the rules of the game!
> 
> > Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

Applied to linux-pm.git/linux-next as v3.8 material.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
