Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab1HLHL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:11:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36478 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab1HLHL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:11:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH v4] PM: add statistics debugfs file for 
 =?iso-8859-1?q?suspend=09to?= ram
Date: Fri, 12 Aug 2011 09:13:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, "Mansoor, Illyas" <illyas.mansoor@intel.com>,
        "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com> <20110810195854.GA5939@suse.de> <20110812070424.GA5249@ucw.cz>
In-Reply-To: <20110812070424.GA5249@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108120913.35046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 12, 2011, Pavel Machek wrote:
> On Wed 2011-08-10 12:58:54, Greg KH wrote:
> > On Thu, Aug 11, 2011 at 01:22:56AM +0530, Mansoor, Illyas wrote:
> > > static pm_message_t pm_transition;
> > > > > >
> > > > > > @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
> > > > > >  		mutex_unlock(&dpm_list_mtx);
> > > > > >
> > > > > >  		error = device_resume_noirq(dev, state);
> > > > > > -		if (error)
> > > > > > +		if (error) {
> > > > > > +			suspend_stats.failed_resume_noirq++;
> > > > > > +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> > > > > > +			dpm_save_failed_dev(dev_name(dev));
> > > > >
> > > > > Please make these statistics conditionally enabled, so on a production system
> > > > > If we need to disable these statistics code we should be able to do so.
> > > > 
> > > > Why, are they taking time or space that is needed for something else?
> > > > What's the downside here of just not always having this enabled?
> > > 
> > > Why have something that is not required/Used?
> > 
> > Because someone might need it and rebuilding a kernel isn't possible on
> > lots of devices.
> 
> Yeah, and someone may need tetris, lets put  it into kernel and enable
> unconditionaly :-(.
> 
> Really, this is just patch to provide dmesg subset, because someone is
> cool enough to hack kernel, but will not just use grep.
> 
> The patch should be just dropped.

And what's the _technical_ reason?

Do you think it's generally wrong to have two different ways of getting
the same debug information from the kernel?

Really, the truth is that suspend debugging is still way too difficult
for the majority of users and I don't quite see a reason to drop patches
that may improve the situation in this area.

Thanks,
Rafael
