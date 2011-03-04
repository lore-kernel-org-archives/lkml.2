Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898Ab1CDQwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:52:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab1CDQwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:52:49 -0500
Date: Fri, 4 Mar 2011 08:52:04 -0800
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Nori, Sekhar" <nsekhar@ti.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        "TK, Pratheesh Gangadhar" <pratheesh@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "sshtylyov@mvista.com" <sshtylyov@mvista.com>,
        "Chatterjee, Amit" <amit.chatterjee@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Message-ID: <20110304165204.GA21244@suse.de>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com>
 <20110304142028.GD28175@local>
 <B85A65D85D7EB246BE421B3FB0FBB593024C009039@dbde02.ent.ti.com>
 <201103041658.05655.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103041658.05655.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:58:05PM +0100, Arnd Bergmann wrote:
> On Friday 04 March 2011, Nori, Sekhar wrote:
> > On Fri, Mar 04, 2011 at 19:50:28, Hans J. Koch wrote:
> > > On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> > > > diff --git a/include/linux/uio_pruss.h b/include/linux/uio_pruss.h
> > > > new file mode 100644
> > > > index 0000000..8c9b2c9
> > > > --- /dev/null
> > > > +++ b/include/linux/uio_pruss.h
> > > 
> > > That should go to arch/arm/mach-davinci/include/mach/
> > > and not to the top level include/linux/ directory.
> > 
> > It was put in here because this driver
> > will be used across two ARM architectures
> > (DaVinci and OMAP). Although it won't be used
> > outside of ARM at least in near future.
> 
> I think include/linux/ is fine for this

No, please use include/linux/platform_data/ instead, that is where
platform data should be going into, not into the "global" space if
include/linux/

> , and arch/arm/include/asm would
> be ok as well. You might want to have only a single pruss header
> file that defines all the platform data for the child drivers, though.
> 
> Ideally, you would of course not need the header at all. This will
> be possible with the move to a flat device tree, where you can store the
> offset as a property of the device
> 
> Another alternative would be to move it to a resource of the platform
> device.

That might be a nice idea for the future.

thanks,

greg k-h
