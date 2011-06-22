Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790Ab1FVMhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 08:37:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45087 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1FVMhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 08:37:37 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>, Tejun Heo <tj@kernel.org>
Subject: Re: Re: [PATCH v6 11/18] input: Add initial support for TWL6040 vibrator
Date: Wed, 22 Jun 2011 14:37:05 +0300
Message-ID: <9447778.OLKFu0QH6G@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110621203200.GA3731@core.coreip.homeip.net>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com> <1308663556-29120-12-git-send-email-peter.ujfalusi@ti.com> <20110621203200.GA3731@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

On Tuesday 21 June 2011 22:32:01 Dmitry Torokhov wrote:
> On Tue, Jun 21, 2011 at 04:39:09PM +0300, Peter Ujfalusi wrote:
> > From: Misael Lopez Cruz <misael.lopez@ti.com>
> > 
> > Add twl6040_vibra as a child of MFD device twl6040_codec. This
> > implementation covers the PCM-to-PWM mode of TWL6040 vibrator
> > module.
> > 
> > Signed-off-by: Misael Lopez Cruz <misael.lopez@ti.com>
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > CC: Tejun Heo <tj@kernel.org>
> 
> Peter,
> 
> As Tejun mentioned, there is no difference between having a "private"
> workqueue created with alloc_workqueue() with default parameters and
> using system-wide workqueue. Therefore please use system-wide one. If
> your use shows that you indeed need high-priority workqueue it can be
> added later.

I have replaced the singlethreaded wq with the call suggested by Tejun:
https://lkml.org/lkml/2011/6/17/99

If this is a problem, I can rework this, and remove the code, which is not 
going to be needed, when the system_wq is in use, but I would like to keep the 
alloc_workqueue way, since it is going to be easier for us to experiment with 
parameters, if we face with issues.
 
> Otherwise:
> 
>         Acked-by: Dmitry Torokhov <dtor@mail.ru>
> 
> Please feel free to merge this code with the rest of TWL6040 patches
> (presumably throgh Samuel's MFD tree).

Thank you,
Péter
