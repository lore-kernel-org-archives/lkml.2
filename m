Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab1HLHFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 03:05:15 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:41523 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1HLHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 03:05:11 -0400
Date: Fri, 12 Aug 2011 09:04:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: "Mansoor, Illyas" <illyas.mansoor@intel.com>,
        "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Message-ID: <20110812070424.GA5249@ucw.cz>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
 <EB6073F1DF78F9439DFDCC701BC6466007B36A0CCE@bgsmsx502.gar.corp.intel.com>
 <20110810194529.GA5590@suse.de>
 <EB6073F1DF78F9439DFDCC701BC6466007B36A0D12@bgsmsx502.gar.corp.intel.com>
 <20110810195854.GA5939@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810195854.GA5939@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-08-10 12:58:54, Greg KH wrote:
> On Thu, Aug 11, 2011 at 01:22:56AM +0530, Mansoor, Illyas wrote:
> > static pm_message_t pm_transition;
> > > > >
> > > > > @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
> > > > >  		mutex_unlock(&dpm_list_mtx);
> > > > >
> > > > >  		error = device_resume_noirq(dev, state);
> > > > > -		if (error)
> > > > > +		if (error) {
> > > > > +			suspend_stats.failed_resume_noirq++;
> > > > > +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> > > > > +			dpm_save_failed_dev(dev_name(dev));
> > > >
> > > > Please make these statistics conditionally enabled, so on a production system
> > > > If we need to disable these statistics code we should be able to do so.
> > > 
> > > Why, are they taking time or space that is needed for something else?
> > > What's the downside here of just not always having this enabled?
> > 
> > Why have something that is not required/Used?
> 
> Because someone might need it and rebuilding a kernel isn't possible on
> lots of devices.

Yeah, and someone may need tetris, lets put  it into kernel and enable
unconditionaly :-(.

Really, this is just patch to provide dmesg subset, because someone is
cool enough to hack kernel, but will not just use grep.

The patch should be just dropped. Use perf or dmesg parsing to collect
data; fix printks() to be easier to grep for if needed.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
