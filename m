Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0KEC1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:27:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab0KEC1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:27:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
Date: Fri, 5 Nov 2010 03:27:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
        Oliver Neukum <oliver@neukum.org>, Valdis.Kletnieks@vt.edu,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org
References: <201009161632.59210.arnd@arndb.de> <20101102012135.GB2648@ucw.cz> <AANLkTim=suDPVCW+dPCxtasbUj=X8EMgGRHAiGO37cGo@mail.gmail.com>
In-Reply-To: <AANLkTim=suDPVCW+dPCxtasbUj=X8EMgGRHAiGO37cGo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011050327.06607.arnd@arndb.de>
X-Provags-ID: V02:K0:p+nyeRVyq/aR8dXn2cXz2/GE48a2laKsnoYQnMW2sJ9
 cGfn+iKKYQApcNmYsgn4SDOgoXc3fZlp/44T/6vemLCD0b/qr2
 r/IxOUVLTgF6eQCwdy1MOq0jNs2/1P8faw8NJ0v1XkBBYRW9iB
 kCUdF+ZgexTd/TqurJJ2/PYFDaXj86/zIU29CFOkhVO/x3fMoF
 QlNTDERjzBdqz+oxw9Rnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 November 2010, Pekka Enberg wrote:
> On Tue, Nov 2, 2010 at 3:21 AM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >> @@ -79,6 +79,10 @@ static struct drm_driver driver = {
> >>
> >>  static int __init i810_init(void)
> >>  {
> >> +     if (num_present_cpus() > 1) {
> >> +             pr_err("drm/i810 does not support SMP\n");
> >> +             return -EINVAL;
> >> +     }
> >>       driver.num_ioctls = i810_max_ioctl;
> >>       return drm_init(&driver);
> >
> > Umm, and now someone onlines second cpu?
> 
> Well, I see it's being fixed in a different way but yeah,
> num_possible_cpus() would be more appropriate here.

(trimming Cc list again)

I thought that patch was still current, what other way are we fixing it now?

Since I'm planning to do one more series for 2.6.37 to take care of the
remaining BKL users, should I push the patch above plus the one that
marks the module as "depends on !PREEMPT || BROKEN", or should that go through
the DRM tree?

Pavel: The only board that has this chipset with multiple sockets is for
Pentium III and does not have hotplug sockets, so num_present_cpus 
is the same as num_possible_cpus here. I can change it to num_possible_cpus
of course.

	Arnd
