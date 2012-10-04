Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab2JDMgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:36:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15799 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab2JDMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:36:31 -0400
X-AuditID: cbfee60c-b7f256d000000e9f-29-506d82cddc11
Date: Thu, 04 Oct 2012 12:36:29 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v4 0/3] devfreq: Add support for devices which can idle
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>
Cc: "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121004123345525@myungjoo.ham
Msgkey: 20121004123345525@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121004123345525@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17446332.558331349354185878.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/t6bpnm3IDDDbs4ba4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjS1fWQumSFT8bt/M3MB4QLyLkZNDSEBdYtGSk2wgtoSAicSf
	xnssELaYxIV769kgauYzSkxfqQtiswioSDQcnAsU5+BgE9CTmPk5GSQsLOAtcXP1b6BWLg4R
	geOMEj83f2ACSTALPGOUOLfdA2KOksSafa/A5vMKCEqcnPkEapeqRO+mM1BxNYkTF84zQsQl
	JGZNv8AKYfNKzGh/ClUvJzHt6xpmCFta4vysDYwwNy/+/hgqzi9x7PYOJpA7QXqf3A+GGbN7
	8xeodwUkpp45CNWqJdF86h/UeD6JNQvfssCM2XVqOTNM7/0tc6HeUpSY0v2QHcLWkvjyYx8b
	urd4BZwkGprns0xglJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkpPNdIrTswtLs1L10vOz93E
	CI7yZzw7GOc0WBxiFOBgVOLh1WzJCRBiTSwrrsw9xCjBwawkwuudmxsgxJuSWFmVWpQfX1Sa
	k1p8iFGag0VJnLfOIyVASCA9sSQ1OzW1ILUIJsvEwSnVwOhYsLaT/1uMZK7q9Jd/XRXeJyit
	ulfwdM27FONovdozta/2JRz9+G2x8j2W/V2vqm5srIhYujpy4ZydxTeda2ZPzHz2dkq2tfH7
	I5FqtVuDU/msy78dM0jqdOJ6UCv2cWthjvkvN0sxe9nXOy/cuL7/oiX33PvZn9Lz1l/i1nzx
	gvWTNifvBl0lluKMREMt5qLiRAD+EOxT7gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q94CaZqt011004

> This patchset updates devfreq core to add support for devices
> which can idle. When device idleness is detected perhaps
> through runtime-pm, need some mechanism to suspend devfreq
> load monitoring and resume when device is back online.
> 
> patch 1 introduce core design changes - per device work, decouple
> delayed work from core and event based interaction.
> patch 2 add devfreq suspend and resume apis.
> patch 3 add new sysfs attribute for governor predicted next target
> frequency and callback for current device frequency.
> 
> The existing devfreq apis are kept intact. Two new apis
> devfreq_suspend_device() and devfreq_resume_device() are
> added to support suspend/resume of device devfreq.

Could you please tell me which version you have rebased?

It seems that the patchset has issues on applying over 3.6.
(tried at a0d271cbfed1dd50278c6b06bead3d00ba0a88f9)


> 
> Changes since v1:
> - revised locking mechanism
> - added kerneldoc comments for load monitoring helper functions
> - fixed minor review comments
> 
> Changes since v2:
> - added new helper function for polling interval update
> - handled work suspend/resume contention between devfreq driver
> and sysfs
> 
> Changes since v3:
> - added additonal checks in suspend/resume to avoid invalid usage of apis
> - added check in devfreq_monitor_start, not to start monitoring when
> polling_ms is set to zero.
> 
> --
> Rajagopal Venkat (3):
>   devfreq: Core updates to support devices which can idle
>   devfreq: Add suspend and resume apis
>   devfreq: Add current freq callback in device profile
> 
>  Documentation/ABI/testing/sysfs-class-devfreq |  15 +-
>  drivers/devfreq/devfreq.c                     | 481 ++++++++++++--------------
>  drivers/devfreq/governor.h                    |  13 +
>  drivers/devfreq/governor_performance.c        |  16 +-
>  drivers/devfreq/governor_powersave.c          |  16 +-
>  drivers/devfreq/governor_simpleondemand.c     |  33 ++
>  drivers/devfreq/governor_userspace.c          |  23 +-
>  include/linux/devfreq.h                       |  49 +--
>  8 files changed, 353 insertions(+), 293 deletions(-)
> 
> -- 
> 1.7.11.3
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
