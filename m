Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2JPGzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:55:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16040 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab2JPGzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:55:51 -0400
X-AuditID: cbfee60c-b7f876d000006a6e-d6-507d01566f1f
Date: Tue, 16 Oct 2012 06:40:22 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 2/3] devfreq: Add suspend and resume apis
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121016063949084@myungjoo.ham
Msgkey: 20121016063949084@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121016063949084@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <12788576.101631350369619343.JavaMail.weblogic@epml27>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t/tmbphjLUBBueXy1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mr0fKC1bIVdw818rewHhAtouRk0NIQF1i0ZKTbCC2hICJxL1j
	vewQtpjEhXvr2SBq5jNKXJxpDWKzCKhKzN1wkrGLkYODTUBPYubnZBBTWMBF4s9pI5AKEaCK
	LU/+A03h4mAWOMcs8a1hLivEGCWJNftesYDYvAKCEidnPmGBWAU0sushK0RcTeLLvdtMEHEJ
	iVnTL7BC2LwSM9qfQtXLSUz7uoYZwpaWOD9rAyPMyYu/P4aK80scu72DCeQ2kN4n94Nhxuze
	/AXqWwGJqWcOQrVqSVz/AHMOn8SahW9ZYMbsOrWcGab3/pa5YKcxCyhKTOl+yA5ha0l8+bGP
	DdVbHEC2k8Sv66oTGOVmIcnMQtI9C0k3spoFjCyrGEVTC5ILipPSU430ihNzi0vz0vWS83M3
	MYLj+xnPDsY5DRaHGAU4GJV4eDXCagKEWBPLiitzDzFKcDArifB6TAQK8aYkVlalFuXHF5Xm
	pBYfYpTmYFES563zSAkQEkhPLEnNTk0tSC2CyTJxcEoBk8X5W1YVXuyTWB2eXiw8+KCtVfzN
	10+3zb9lz76j3t23bHtQegc3Z3D6tx/CwgWn40yUnuwX9hH5Gm1YlbBFXfXxVm02/5OO8sym
	658fdg/P+PtGZNtk09zTTZJ8E7lS47ZJ3OA+ef1ZbcaB2spd809efvOQxc3wubvBTt8Dn2+d
	W/LkWZXNUiWW4oxEQy3mouJEAELw7P7rAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9G6twJf029966

> On Monday 08 of October 2012 10:48:24 MyungJoo Ham wrote:
> > > On 8 October 2012 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Thursday 04 of October 2012 14:58:33 Rajagopal Venkat wrote:
> > > >> Add devfreq suspend/resume apis for devfreq users. This patch
> > > >> supports suspend and resume of devfreq load monitoring, required
> > > >> for devices which can idle.
> > > >>
> > > >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > > >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > > >
> > > > Well, I wonder if this may be tied in to the runtime PM framework, so that,
> > > > for example, pm_runtime_suspend() will automatically suspend devfreq on
> > > > success (and the runtime resume of the device will resume devfreq)?
> > > 
> > > That's a good idea. If you agree, we can handle this as separate patch on
> > > top this patchset.
> 
> Sure.
> 
> > I guess implementing the idea may be not so obvious; thus, seperating
> > the patchset would be appropriate.
> > 
> > When we implement the idea, we may need to implement at the
> > pm_runtime core. Because devfreq->dev is a child of the target dev, not
> > a parent, runtime-pm event of the target dev does not automatically
> > invoke a cascaded action on the devfreq->dev.
> 
> I'm not exactly sure what you mean, care to explain?

When a device "p" creates devfreq, devfreq->dev->parent = p.
And, devfreq's functions need to react to the "p"'s runtime-pm events.

However, when "p"'s runtime-pm-suspend is being invoked,
devfreq->dev's runtime-pm-suspend won't be automatically invoked.

Thus, we will need a mechanism that invokes devfreq->dev's runtime-pm
callbacks when p's runtime-pm is invoked. (at the runtime-pm core)
Or
A mechanism that one can notify others (including its children) when
the one's runtime-pm is invoked. (probably at the runtime-pm core, too)

Without such support, it appears that the current implementation
(calling runtime-pm suspend/resume equivalent devfreq functions
manually at device drivers) seems to be inevitable.



Anyway, if devfreq->dev is a parent of "p", runtime-pm core will
do the required task automatically; however, it isn't and I don't
think it'd be appropriate.

> 
> > Maybe either
> > 1) capability to allow a child to monitor the power state of a parent
> > (I remember Inki Dae once suggested to add notifiers at runtime-pm, but
> > it seems to be not merged)
> > or
> > 2) letting runtime-pm be aware of devfreq
> > (doesn't feel alright with this??)
> > is required?
> 
> I'm not a big fan of notifiers, so I'd prefer to avoid using them, if
> possible.
> 
> Thanks,
> Rafael
> 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> 

Cheers,
MyungJoo
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
