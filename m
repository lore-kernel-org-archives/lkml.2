Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2HaXWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:22:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64996 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:22:40 -0400
Date: Fri, 31 Aug 2012 16:22:34 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20120831232234.GB22142@core.coreip.homeip.net>
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
 <20120830230129.GC21501@core.coreip.homeip.net>
 <50413200.5010104@linaro.org>
 <20120831230227.6e5008b5@pyramind.ukuu.org.uk>
 <20120831224128.GA22073@core.coreip.homeip.net>
 <50414140.60102@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50414140.60102@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 04:57:04PM -0600, Mathieu Poirier wrote:
> On 12-08-31 04:41 PM, Dmitry Torokhov wrote:
> > On Fri, Aug 31, 2012 at 11:02:27PM +0100, Alan Cox wrote:
> >>>> Why do we need to involve a platform device and not use, for example, a module
> >>>> parameter, that could be set up from userspace?
> >>>
> >>> The platform device comes from the original design and was included to
> >>> minimise the amount of changes in code that make use of the current
> >>> keyreset driver.
> >>
> >> The platform device is IMHO the right answer. In this class of devices
> >> the stuff is compiled in, the userspace is Android, there are no modules
> >> and there is no reason for it to be configurable.
> > 
> > It does not matter if it is built in or not, /sys/module/XXX/parameters
> > is still there, and while havig it in kernel is "easy" you could as
> > easily stuff needed data into a sysfs attribute during booting.
> > 
> > And we should be able to get this from DT even without the platform
> > device (this was the next step, wasn't it?).
> 
> Correct - my hope was to get the main functionality accepted before
> adding DT support.  Do you think the lack of DT support is a blocker for
> acceptance ?  Please confirm.
> 

No, lack of DT is not a blocker, but I am unconvinced that we need
platform device.

Thanks,

-- 
Dmitry
