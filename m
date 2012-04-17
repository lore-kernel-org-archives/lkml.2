Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2DQVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:06:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab2DQVGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:06:03 -0400
Date: Tue, 17 Apr 2012 17:05:50 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        harald@redhat.com
Subject: Re: tg3 'No PHY devices' loading issue
Message-ID: <20120417210549.GI19507@zod.bos.redhat.com>
References: <20120417141856.GA19507@zod.bos.redhat.com>
 <20120417185007.GA3742@mcarlson.broadcom.com>
 <20120417193908.GG19507@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417193908.GG19507@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 03:39:08PM -0400, Josh Boyer wrote:
> On Tue, Apr 17, 2012 at 11:50:07AM -0700, Matt Carlson wrote:
> > On Tue, Apr 17, 2012 at 10:18:57AM -0400, Josh Boyer wrote:
> > > It has worked on some of the older kernels without the need for the
> > > manual rmmod/modprobe step, so it seems to be somewhat timing related.
> > > I'm not sure if there is a module load ordering issue, but that doesn't
> > > seem to be the case.  I can't explain why a later modprobe would work
> > > just fine though.
> > > 
> > > Do you have any thoughts on how to go about debugging/fixing this?  I'd
> > > be happy to test and provide whatever information you need.
> > 
> > The 57788 uses the broadcom phylib module.  For some reason, it isn't
> > available the first module load attempt.  A while ago, code was added to
> > phylib to request modules from userspace if the particular phy support
> > code wasn't already loaded.  It looks like this mechanism isn't working
> > too well the first time through.
> > 
> > Can you reproduce the problem if you run 'rmmod broadcom' and then
> > reload tg3?
> 
> I'll give it a shot, but that sounds like a quite plausible scenario to
> me.  Oddly, even after the manual modprobe, the broadcom phy module
> doesn't show an increased use count.  There's also no dependency on
> 'broadcom' listed for tg3 by modinfo.

If I rmmod both tg3 and broadcom and then just load tg3 (either via
insmod or modprobe), it works fine.  It does so because whatever you did
to make it request the phylib module from userspace also worked because
the broadcom module is loaded as well.

So it seems my issue is basically because the initramfs isn't built with
the broadcom module included.  I'll have to figure out a way to teach
dracut what to do here, since it doesn't seem to be automatically
picking it up (Harald CC'd).

Thanks much for the very quick response from everyone.

josh
