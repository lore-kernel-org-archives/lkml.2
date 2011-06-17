Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1FQIgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:36:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55236 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab1FQIgA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:36:00 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: <alsa-devel@alsa-project.org>
CC: Tejun Heo <tj@kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: Re: Re: [alsa-devel] [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Fri, 17 Jun 2011 12:39:57 +0300
Message-ID: <5740779.B2nyl9oMW4@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <4306005.scnJ1lQX4P@barack>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <20110616120244.GA2611@htj.dyndns.org> <4306005.scnJ1lQX4P@barack>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

On Thursday 16 June 2011 16:06:00 Ujfalusi, Peter wrote:
> > I suppose you meant alloc_workqueue()? :)
> 
> Oh, yes. I mean that.

Just avoid another series...
I have looked at the alloc_workqueue, and I'm not really sure what parameters 
should I use.
#define create_singlethread_workqueue(name)			\
	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)

I would use something like this instead of create_singlethread_workqueue:

alloc_workqueue("twl6040-vibra", WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);

Is this correct?

Thanks,
Péter
