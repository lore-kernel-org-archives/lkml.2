Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab2ADTvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:51:45 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60306 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2ADTvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:51:43 -0500
Date: Wed, 4 Jan 2012 14:51:34 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, gregkh@suse.de, linux-pci@vger.kernel.org
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
Message-ID: <20120104195134.GB24324@hmsreliant.think-freely.org>
References: <1325604594-7184-1-git-send-email-nhorman@tuxdriver.com>
 <20120103.130526.2034128205205666131.davem@davemloft.net>
 <20120103185304.GA25184@hmsreliant.think-freely.org>
 <20120104091952.7cc5316d@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104091952.7cc5316d@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 09:19:52AM -0800, Jesse Barnes wrote:
> On Tue, 3 Jan 2012 13:53:05 -0500
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > On Tue, Jan 03, 2012 at 01:05:26PM -0500, David Miller wrote:
> > > From: Neil Horman <nhorman@tuxdriver.com>
> > > Date: Tue,  3 Jan 2012 10:29:54 -0500
> > > 
> > > > This warning was recently reported to me:
> > > 
> > > I've hit this too, see:
> > > 
> > > http://marc.info/?l=linux-kernel&m=132458146927890&w=2
> > > 
> > > and my analysis at:
> > > 
> > > http://marc.info/?l=linux-arch&m=132458391128660&w=2
> > > 
> > Yup, your analysis is correct. Regardless of the why behind msi enablement
> > failing, we need to gate the kobject_del/put in free_msi_irqs on successful
> > completion of kobject_init_and_add in populate_msi_sysfs.  This patch does that,
> > using the parent pointer as a flag.
> 
> I applied this to my -next branch; doesn't seem critical to land
> immediately.  If you disagree let me know and I'll pull it over to my
> for-linus branch instead.
> 
> Thanks,
I'm ok with it waiting, but I'll defer to Dave and others who have seen it
occur.  It sounds like its alot of log noise.
Neil

> -- 
> Jesse Barnes, Intel Open Source Technology Center


