Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab2JEGpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:45:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63170 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2JEGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:45:50 -0400
X-AuditID: cbfee60d-b7efc6d00000696b-22-506e71b1ca43
Date: Fri, 05 Oct 2012 05:35:45 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 0/3] devfreq: Add support for devices which can idle
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121005052648945@myungjoo.ham
Msgkey: 20121005052648945@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121005052648945@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18773389.596021349415342692.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tGbobC/MCDD7sN7O4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDz+cYS54JFexe+9q9gbGH7JdjJwcQgLqEouWnGQDsSUETCQe
	/13CCGGLSVy4tx4ozgVUM59R4vjLG8wgCRYBFYltnzaxdzFycLAJ6EnM/JwMEhYW8Jd48mAi
	WK8I0JzJh74wg/QyC/xkkvjwag8zxDIliTX7XrGA2LwCghInZz5hAZkjIaAq8e6GPkRYTaLj
	1jp2iBskJGZNv8AKYfNKzGh/ygJhy0lM+7qGGcKWljg/awPczYu/P4aK80scu72DCWI8r8ST
	+8EwY3Zv/gL1roDE1DMHoVq1JD71zIJq5ZNYs/AtC8yYXaeWM8P03t8ylwnEZhZQlJjS/ZAd
	wtaS+PJjHxuqr0BsJ4nfcxYxTWCUm4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSk811itOzC0u
	zUvXS87P3cQIjvJnvDsY5zZYHGIU4GBU4uHNeJEbIMSaWFZcmXuIUYKDWUmE92pSXoAQb0pi
	ZVVqUX58UWlOavEhRmkOFiVx3nqPlAAhgfTEktTs1NSC1CKYLBMHp1QDo1W6rvGe69cTdXMF
	OrxPMXumf4+qK7ufLnNFYfvLH8/fvuHvCH27WqVQQ/0Yo11wlubd7U+WR1b8kLEpDQoVkysL
	+9/bc7d/mv8G5Rdrzh07lHij5mSmc+P6rF7Z8vyvXM9sOH/ZJ54TkGu79vR4b8HvvoNZzuyG
	93UU3LuvPLDOvz277vsUJZbijERDLeai4kQA0ABiPO4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q956jvRj017319

> On 4 October 2012 18:06, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> >> This patchset updates devfreq core to add support for devices
> >> which can idle. When device idleness is detected perhaps
> >> through runtime-pm, need some mechanism to suspend devfreq
> >> load monitoring and resume when device is back online.
> >>
> >> patch 1 introduce core design changes - per device work, decouple
> >> delayed work from core and event based interaction.
> >> patch 2 add devfreq suspend and resume apis.
> >> patch 3 add new sysfs attribute for governor predicted next target
> >> frequency and callback for current device frequency.
> >>
> >> The existing devfreq apis are kept intact. Two new apis
> >> devfreq_suspend_device() and devfreq_resume_device() are
> >> added to support suspend/resume of device devfreq.
> >
> > Could you please tell me which version you have rebased?
> >
> > It seems that the patchset has issues on applying over 3.6.
> > (tried at a0d271cbfed1dd50278c6b06bead3d00ba0a88f9)
> 
> These patches are rebased against Linus tree.
> 
> The 203b42f7317494ae5e5efc7be6fb7f29c927f102 commit, which
> renames INIT_DELAYED_WORK_DEFERRABLE to
> INIT_DEFERRABLE_WORK could be the reason for patchset
> not applying over 3.6.

Ok, I'll try and test over Linus' latest.

> 
> >
> >
> >>
> >> Changes since v1:
> >> - revised locking mechanism
> >> - added kerneldoc comments for load monitoring helper functions
> >> - fixed minor review comments
> >>
> >> Changes since v2:
> >> - added new helper function for polling interval update
> >> - handled work suspend/resume contention between devfreq driver
> >> and sysfs
> >>
> >> Changes since v3:
> >> - added additonal checks in suspend/resume to avoid invalid usage of apis
> >> - added check in devfreq_monitor_start, not to start monitoring when
> >> polling_ms is set to zero.
> >>
> >> --
> >> Rajagopal Venkat (3):
> >>   devfreq: Core updates to support devices which can idle
> >>   devfreq: Add suspend and resume apis
> >>   devfreq: Add current freq callback in device profile
> >>
> >>  Documentation/ABI/testing/sysfs-class-devfreq |  15 +-
> >>  drivers/devfreq/devfreq.c                     | 481 ++++++++++++--------------
> >>  drivers/devfreq/governor.h                    |  13 +
> >>  drivers/devfreq/governor_performance.c        |  16 +-
> >>  drivers/devfreq/governor_powersave.c          |  16 +-
> >>  drivers/devfreq/governor_simpleondemand.c     |  33 ++
> >>  drivers/devfreq/governor_userspace.c          |  23 +-
> >>  include/linux/devfreq.h                       |  49 +--
> >>  8 files changed, 353 insertions(+), 293 deletions(-)
> >>
> >> --
> >> 1.7.11.3
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >>
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
