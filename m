Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1HJT7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:59:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1HJT7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:59:34 -0400
Date: Wed, 10 Aug 2011 12:58:54 -0700
From: Greg KH <gregkh@suse.de>
To: "Mansoor, Illyas" <illyas.mansoor@intel.com>
Cc: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v4] PM: add statistics debugfs file for
 suspend	to ram
Message-ID: <20110810195854.GA5939@suse.de>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
 <EB6073F1DF78F9439DFDCC701BC6466007B36A0CCE@bgsmsx502.gar.corp.intel.com>
 <20110810194529.GA5590@suse.de>
 <EB6073F1DF78F9439DFDCC701BC6466007B36A0D12@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EB6073F1DF78F9439DFDCC701BC6466007B36A0D12@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 01:22:56AM +0530, Mansoor, Illyas wrote:
> static pm_message_t pm_transition;
> > > >
> > > > @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
> > > >  		mutex_unlock(&dpm_list_mtx);
> > > >
> > > >  		error = device_resume_noirq(dev, state);
> > > > -		if (error)
> > > > +		if (error) {
> > > > +			suspend_stats.failed_resume_noirq++;
> > > > +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> > > > +			dpm_save_failed_dev(dev_name(dev));
> > >
> > > Please make these statistics conditionally enabled, so on a production system
> > > If we need to disable these statistics code we should be able to do so.
> > 
> > Why, are they taking time or space that is needed for something else?
> > What's the downside here of just not always having this enabled?
> 
> Why have something that is not required/Used?

Because someone might need it and rebuilding a kernel isn't possible on
lots of devices.

> Its only useful if DEBUGFS is configured anyways

Almost all systems these days have debugfs enabled, so that's a moot
point.

greg k-h
