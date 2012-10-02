Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2JBFmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:42:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51431 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2JBFlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:41:51 -0400
X-AuditID: cbfee612-b7f946d000000e97-fd-506a7e9c14e4
Date: Tue, 02 Oct 2012 05:41:48 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v3 1/3] devfreq: Core updates to support devices which
 can idle
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121002050057477@myungjoo.ham
Msgkey: 20121002050057477@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121002050057477@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <25815442.471031349156505509.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/tGbpz6rICDE5/17S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZTyd8ZynoMKn4/5q3gfGGURcjJ4eQgLrEoiUn2UBsCQETiR3r
	TzNB2GISF+6tB4pzAdXMZ5S4eOQAM0iCRUBF4u78C0AJDg42AT2JmZ+TQcLCAuESkw88YwGx
	RYDmTD70hRmkl1ngJ5PEh1d7mCGWKUms2fcKrIhXQFDi5MwnLCBzJARUJfZ8ZYQIq0msbN7N
	AnGDhMSs6RdYIWxeiRntT6HichLTvq5hhrClJc7P2sAIc/Pi74+h4vwSx27vYIIYzyvx5H4w
	zJjdm79AvSsgMfXMQahWLYkvzROgbD6JNQvfssCM2XVqOTNM7/0tc8HBwyygKDGl+yE7hA3U
	+2MfG6qvQGwnie/Nf5gnMMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelp1roFSfmFpfmpesl
	5+duYgTH+DOhHYzLGiwOMQpwMCrx8BZczQwQYk0sK67MPcQowcGsJMLr+QsoxJuSWFmVWpQf
	X1Sak1p8iFGag0VJnLfCIyVASCA9sSQ1OzW1ILUIJsvEwSnVwNjHX1gjX+Ym/bioZPbJy3Pl
	Pp1geMjI/PW4yqsPh1X6Z1ZW3XQv1ApiPit7WECy7P1kmTsc+qf4F72ZIpaUsG9jeNDHP/P2
	37gY8J59x5wLPy3ynIrOci4XKCrTn9g6cw7XSpsHy4KjaiVyFYM2f1Dyzf3kWj+rq3xd6vy+
	xX1ym8z2qU55wqzEUpyRaKjFXFScCADDx9Zm7QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q925gwbD030408

> On 27 September 2012 13:50, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> >> Prepare devfreq core framework to support devices which
> >> can idle. When device idleness is detected perhaps through
> >> runtime-pm, need some mechanism to suspend devfreq load
> >> monitoring and resume back when device is online. Present
> >> code continues monitoring unless device is removed from
> >> devfreq core.
> >>
> >> This patch introduces following design changes,
> >>
> >> - use per device work instead of global work to monitor device
> >>   load. This enables suspend/resume of device devfreq and
> >>   reduces monitoring code complexity.
> >> - decouple delayed work based load monitoring logic from core
> >>   by introducing helpers functions to be used by governors. This
> >>   provides flexibility for governors either to use delayed work
> >>   based monitoring functions or to implement their own mechanism.
> >> - devfreq core interacts with governors via events to perform
> >>   specific actions. These events include start/stop devfreq.
> >>   This sets ground for adding suspend/resume events.
> >>
> >> The devfreq apis are not modified and are kept intact.
> >>
> >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> >
> > Hello,
> >
> >
> > I'll do more through review tomorrow (sorry, I was occuppied by
> > something other than Linux tasks for a while again); however,
> > there are two concerns in this patch.
> >
> > 1. (minor but may bothersome in some rare but not-ignorable cases)
> > Serialization issue between suspend/resume
> > functions; this may happen with some failure or interrupts while entering STR or
> > unexpected usage of the API at drivers.
> 
> Regarding the invalid usage of suspend/resume apis, we can have
> additional checks
> something like,
> 
> void devfreq_monitor_suspend(struct devfreq *devfreq)
> {
>         .....
>         if (devfreq->stop_polling)
>                 return;
>         ......
> }
> 
> void devfreq_monitor_resume(struct devfreq *devfreq)
> {
>         .....
>         if (!devfreq->stop_polling)
>                 return;
>         ......
> }
> 
> >
> >   For example, if devfreq_monitor_suspend() and devfreq_montir_resume() are called
> > almost simultaneously, we may execute 1) locked part of suspend, 2) locked part of
> > resume, 3) cancel_delayed_work_sync of suspend.
> >
> >   Then, we may have stop_polling = false w/ cancel_delayed_work_sync() in effect.
> >
> >   Let's not assume that suspend() and resume() may called almost simultaneously,
> > especially in subsystem core code.

(sorry, I missed "not be" between "may" and "called" here)

> >
> 
> These devfreq_monitor_suspend() and devfreq_monitor_resume() functions are
> executed when device idleness is detected. Perhaps,
> - using runtime-pm: the runtime_suspend() and runtime_resume() are mutually
> exclusive and is guaranteed not to run in parallel.
> - driver may have its own mechanism: in my opinion, driver should ensure
> suspend/resume are sequential even for it to know its devfreq status.
> 
> Assuming even if above sequence occurs, I don't see any problem having
> stop_polling = false w/ cancel_delayed_work_sync() in effect. Since the suspend
> is the last one to complete, monitoring will not continue.

Why don't you simply extend the mutex-locked context?

I.e., 
+	mutex_lock(&devfreq->lock);
+	devfreq->stop_polling = true;
+	mutex_unlock(&devfreq->lock);
+	cancel_delayed_work_sync(&devfreq->work);
-->
+	mutex_lock(&devfreq->lock);
+	devfreq->stop_polling = true;
+	cancel_delayed_work_sync(&devfreq->work);
+	mutex_unlock(&devfreq->lock);

This serializes data-update and the execution based on the data-update,
resolving any inconsistency issues with the queue-status and devfreq
variable.

It doesn't have a heavy overhead to extend it and we have the
probably of inconsistency due to serialization issues.

> 
> >
> > 2. What if polling_ms = 0 w/ active governors (such as ondemand)?
> >
> >  Users may declare the initial polling_ms = 0 w/ simple-ondemand in order to
> > pause sampling at boot-time and start sampling at run-time some time later.
> >
> > It appears that this patch will start forcibly at boot-time in such a case.
> 
> Yes. This is a valid case which can be handled by
> 
>  void devfreq_monitor_start(struct devfreq *devfreq)
>  {
>         INIT_DELAYED_WORK_DEFERRABLE(&devfreq->work, devfreq_monitor);
> +       if (devfreq->profile->polling_ms)
>                 queue_delayed_work(devfreq_wq, &devfreq->work,
>                         msecs_to_jiffies(devfreq->profile->polling_ms));
>  }


Please add the checking statement to every queue_delayed_work() statement:
resume and interval-update functions.



Cheers!
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
