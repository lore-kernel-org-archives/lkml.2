Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2JOUkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:40:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47953 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab2JOUkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:40:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@samsung.com
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] devfreq: Add suspend and resume apis
Date: Mon, 15 Oct 2012 22:43:51 +0200
Message-ID: <13521737.MW7piF1i8B@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <5414519.716731349693303781.JavaMail.weblogic@epml02>
References: <5414519.716731349693303781.JavaMail.weblogic@epml02>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 of October 2012 10:48:24 MyungJoo Ham wrote:
> > On 8 October 2012 03:31, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Thursday 04 of October 2012 14:58:33 Rajagopal Venkat wrote:
> > >> Add devfreq suspend/resume apis for devfreq users. This patch
> > >> supports suspend and resume of devfreq load monitoring, required
> > >> for devices which can idle.
> > >>
> > >> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > >> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > >
> > > Well, I wonder if this may be tied in to the runtime PM framework, so that,
> > > for example, pm_runtime_suspend() will automatically suspend devfreq on
> > > success (and the runtime resume of the device will resume devfreq)?
> > 
> > That's a good idea. If you agree, we can handle this as separate patch on
> > top this patchset.

Sure.

> I guess implementing the idea may be not so obvious; thus, seperating
> the patchset would be appropriate.
> 
> When we implement the idea, we may need to implement at the
> pm_runtime core. Because devfreq->dev is a child of the target dev, not
> a parent, runtime-pm event of the target dev does not automatically
> invoke a cascaded action on the devfreq->dev.

I'm not exactly sure what you mean, care to explain?

> Maybe either
> 1) capability to allow a child to monitor the power state of a parent
> (I remember Inki Dae once suggested to add notifiers at runtime-pm, but
> it seems to be not merged)
> or
> 2) letting runtime-pm be aware of devfreq
> (doesn't feel alright with this??)
> is required?

I'm not a big fan of notifiers, so I'd prefer to avoid using them, if
possible.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
