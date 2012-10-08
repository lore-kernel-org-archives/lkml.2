Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2JHKsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:48:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11667 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2JHKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:48:28 -0400
X-AuditID: cbfee60e-b7fd36d000001c9c-b6-5072af7b161e
Date: Mon, 08 Oct 2012 10:48:27 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 2/3] devfreq: Add suspend and resume apis
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121008104817909@myungjoo.ham
Msgkey: 20121008104817909@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121008104817909@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <5414519.716731349693303781.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/tmbrV64sCDFa95LS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ9y/NYi745VDxs2kHUwPjAvsuRk4OIQF1iUVLTrKB2BICJhKn
	dyxghLDFJC7cWw8U5wKqmc8o8WNPIytIgkVARaJjSjtTFyMHB5uAnsTMz8kgprCAi8Sf00Yg
	FSICkRK//nayg7QyC9xikvj0aSErxC4liTX7XrGA2LwCghInZz5hgdilKjFl01pGiLiaxIf7
	H6DiEhKzpl9ghbB5JWa0P4WKy0lM+7qGGcKWljg/awPczYu/P4aK80scu70D7EyQ3if3g2HG
	7N78BepdAYmpZw4yQpRoSRz/pw8R5pNYs/AtC8yUXaeWM8O03t8ylwnEZhZQlJjS/ZAdwtaS
	+PJjHxu6r3gFHCXWbPjBMoFRbhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4KT3VRK84Mbe4NC9d
	Lzk/dxMjOMaf8e1gnNdgcYhRgINRiYf3g15RgBBrYllxZe4hRgkOZiUR3tR+oBBvSmJlVWpR
	fnxRaU5q8SFGaQ4WJXHeeo+UACGB9MSS1OzU1ILUIpgsEwenVANjStndGQY8H6cdSe5yiUtY
	UO9zVmLiAu+IV78P/T85ex/7nK7zHqz3WcV0LszSXjLlXbfZxT36IRe5aqpkWx7unNF9yvq4
	v3Ldlrvp/0887coNUWU6Inj8wfc5e5cKbP/4SmK/3vHsb+tUJitJPe/6u/Xh1YxWLttpkSkZ
	WhqTrm/+Zfs8TvvxeyWW4oxEQy3mouJEAJoNPkDtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q98AmbeN030653

> On 8 October 2012 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday 04 of October 2012 14:58:33 Rajagopal Venkat wrote:
> >> Add devfreq suspend/resume apis for devfreq users. This patch
> >> supports suspend and resume of devfreq load monitoring, required
> >> for devices which can idle.
> >>
> >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >
> > Well, I wonder if this may be tied in to the runtime PM framework, so that,
> > for example, pm_runtime_suspend() will automatically suspend devfreq on
> > success (and the runtime resume of the device will resume devfreq)?
> 
> That's a good idea. If you agree, we can handle this as separate patch on
> top this patchset.

I guess implementing the idea may be not so obvious; thus, seperating
the patchset would be appropriate.

When we implement the idea, we may need to implement at the
pm_runtime core. Because devfreq->dev is a child of the target dev, not
a parent, runtime-pm event of the target dev does not automatically
invoke a cascaded action on the devfreq->dev.

Maybe either
1) capability to allow a child to monitor the power state of a parent
(I remember Inki Dae once suggested to add notifiers at runtime-pm, but
it seems to be not merged)
or
2) letting runtime-pm be aware of devfreq
(doesn't feel alright with this??)
is required?



> 
> >
> > Rafael
> >
> >
> >> ---
> >>  drivers/devfreq/devfreq.c                 | 28 ++++++++++++++++++++++++++++
> >>  drivers/devfreq/governor.h                |  2 ++
> >>  drivers/devfreq/governor_simpleondemand.c |  9 +++++++++
> >>  include/linux/devfreq.h                   | 12 ++++++++++++
> >>  4 files changed, 51 insertions(+)
> >>
> >> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> >> index 41a4099..63e075e 100644
> >> --- a/drivers/devfreq/devfreq.c
> >> +++ b/drivers/devfreq/devfreq.c
> >> @@ -428,6 +428,34 @@ int devfreq_remove_device(struct devfreq *devfreq)
> >>  }
> >>  EXPORT_SYMBOL(devfreq_remove_device);
> >>
> >> +/**
> >> + * devfreq_suspend_device() - Suspend devfreq of a device.
> >> + * @devfreq  the devfreq instance to be suspended
> >> + */
> >> +int devfreq_suspend_device(struct devfreq *devfreq)
> >> +{
> >> +     if (!devfreq)
> >> +             return -EINVAL;
> >> +
> >> +     return devfreq->governor->event_handler(devfreq,
> >> +                             DEVFREQ_GOV_SUSPEND, NULL);
> >> +}
> >> +EXPORT_SYMBOL(devfreq_suspend_device);
> >> +
> >> +/**
> >> + * devfreq_resume_device() - Resume devfreq of a device.
> >> + * @devfreq  the devfreq instance to be resumed
> >> + */
> >> +int devfreq_resume_device(struct devfreq *devfreq)
> >> +{
> >> +     if (!devfreq)
> >> +             return -EINVAL;
> >> +
> >> +     return devfreq->governor->event_handler(devfreq,
> >> +                             DEVFREQ_GOV_RESUME, NULL);
> >> +}
> >> +EXPORT_SYMBOL(devfreq_resume_device);
> >> +
> >>  static ssize_t show_governor(struct device *dev,
> >>                            struct device_attribute *attr, char *buf)
> >>  {
> >> diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
> >> index bb3aff3..26432ac 100644
> >> --- a/drivers/devfreq/governor.h
> >> +++ b/drivers/devfreq/governor.h
> >> @@ -22,6 +22,8 @@
> >>  #define DEVFREQ_GOV_START                    0x1
> >>  #define DEVFREQ_GOV_STOP                     0x2
> >>  #define DEVFREQ_GOV_INTERVAL                 0x3
> >> +#define DEVFREQ_GOV_SUSPEND                  0x4
> >> +#define DEVFREQ_GOV_RESUME                   0x5
> >>
> >>  /* Caution: devfreq->lock must be locked before calling update_devfreq */
> >>  extern int update_devfreq(struct devfreq *devfreq);
> >> diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
> >> index cf94218..a8ba78c 100644
> >> --- a/drivers/devfreq/governor_simpleondemand.c
> >> +++ b/drivers/devfreq/governor_simpleondemand.c
> >> @@ -104,6 +104,15 @@ int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
> >>       case DEVFREQ_GOV_INTERVAL:
> >>               devfreq_interval_update(devfreq, (unsigned int *)data);
> >>               break;
> >> +
> >> +     case DEVFREQ_GOV_SUSPEND:
> >> +             devfreq_monitor_suspend(devfreq);
> >> +             break;
> >> +
> >> +     case DEVFREQ_GOV_RESUME:
> >> +             devfreq_monitor_resume(devfreq);
> >> +             break;
> >> +
> >>       default:
> >>               break;
> >>       }
> >> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> >> index 9cdffde..ee243a3 100644
> >> --- a/include/linux/devfreq.h
> >> +++ b/include/linux/devfreq.h
> >> @@ -158,6 +158,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
> >>                                 const struct devfreq_governor *governor,
> >>                                 void *data);
> >>  extern int devfreq_remove_device(struct devfreq *devfreq);
> >> +extern int devfreq_suspend_device(struct devfreq *devfreq);
> >> +extern int devfreq_resume_device(struct devfreq *devfreq);
> >>
> >>  /* Helper functions for devfreq user device driver with OPP. */
> >>  extern struct opp *devfreq_recommended_opp(struct device *dev,
> >> @@ -211,6 +213,16 @@ static int devfreq_remove_device(struct devfreq *devfreq)
> >>       return 0;
> >>  }
> >>
> >> +static int devfreq_suspend_device(struct devfreq *devfreq)
> >> +{
> >> +     return 0;
> >> +}
> >> +
> >> +static int devfreq_resume_device(struct devfreq *devfreq)
> >> +{
> >> +     return 0;
> >> +}
> >> +
> >>  static struct opp *devfreq_recommended_opp(struct device *dev,
> >>                                          unsigned long *freq, u32 flags)
> >>  {
> >>
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
> 
> 
> 
> -- 
> Regards,
> Rajagopal
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
