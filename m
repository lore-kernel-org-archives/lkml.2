Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab1FPKLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:11:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49487 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab1FPKLh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:11:37 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Thu, 16 Jun 2011 14:13:59 +0300
Message-ID: <5476342.2jZLF0UGcI@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110615082301.GN8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <20110615081858.GM8141@htj.dyndns.org> <20110615082301.GN8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 June 2011 10:23:01 Tejun Heo wrote:
> On Wed, Jun 15, 2011 at 10:18:58AM +0200, Tejun Heo wrote:
> > No human being can feel 120usec difference and I can't see how using
> > HIGHPRI is justified here (which is what the code is doing
> > _accidentally_ by using singlethread_workqueue).
> 
> Ooh, one more thing, and even if you insist on using HIGHPRI (please
> don't), you don't need to create workqueue for each device.  You can
> just create one for the whole driver in init and destroy it from exit.
> What matters is the HIGHPRI attribute of the workqueue.  The number of
> workqueues is completely irrelevant.

Fair enough.
I'll move to create_workqueue.
If we later find issues with this (in a 'live' system), we can figure out a 
way to fix it.

Thank you for your time on this.
I'll make the changes accordingly.

Regards,
Péter
