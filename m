Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1GESnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:43:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57838 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1GESnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:43:14 -0400
From: "Watkins, Melissa" <m-watkins@ti.com>
To: Greg KH <greg@kroah.com>, Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "sachi@mistralsolutions.com" <sachi@mistralsolutions.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "stalin.s@mistralsolutions.com" <stalin.s@mistralsolutions.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 5 Jul 2011 13:43:03 -0500
Subject: RE: [PATCH v5 1/1] drivers:staging:pruss: add pruss staging mfd
 driver.
Thread-Topic: [PATCH v5 1/1] drivers:staging:pruss: add pruss staging mfd
 driver.
Thread-Index: Acw7Lv0xtZpxtujdRf24ekFvFuT0wwAEsrSg
Message-ID: <131E5DFBE7373E4C8D813795A6AA7F08034B5C4C48@dlee06.ent.ti.com>
References: <1306827939-4133-1-git-send-email-subhasish@mistralsolutions.com>
 <1306827939-4133-2-git-send-email-subhasish@mistralsolutions.com>
 <20110628210112.GA31081@kroah.com> <20110705161558.GA26309@kroah.com>
In-Reply-To: <20110705161558.GA26309@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 02:01:12PM -0700, Greg KH wrote:
> On Tue, May 31, 2011 at 01:15:39PM +0530, Subhasish Ghosh wrote:
> > > This patch adds the pruss MFD driver and associated include files.
> > > For details regarding the PRUSS please refer the folowing link:
> > > http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
> > > 
> > > The rational behind the MFD driver being the fact that multiple devices can
> > > be implemented on the cores independently. This is determined by the nature
> > > of the program which is loaded into the PRU's instruction memory.
> > > A device may be de-initialized and another loaded or two different devices
> > > can be run simultaneously on the two cores.
> > > It's also possible, as in our case, to implement a single device on both
> > > the PRU's resulting in improved load sharing.
> > > 
> > > Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> > 

[MW] Greg, thanks for reviewing Mistral's patch submission.  I have been following the traffic on their patches and will provide an initial response to address some of your questions. 

> > Please refresh my memory as to why this can't get merged into the
> > "normal" part of the kernel?

[MW] Arnd had recommended moving the driver to the staging area until all interfaces have stabilized.  One of the main reasons it cannot currently be merged in the "normal" part of the kernel is the question of how firmware should be configured and loaded. (https://lkml.org/lkml/2011/5/24/230, https://lkml.org/lkml/2011/5/10/463)

> Dropped from my queue due to lack of response :(

> Please resend when you get the chance, and address the above comment in
> your changelog entry (and in your TODO file as well.)

[MW] Please let us know if Mistral still needs to resubmit their patch or if we can continue discussions on this submission.

> > > --- /dev/null
> > > +++ b/drivers/staging/pruss/TODO
> > > @@ -0,0 +1,14 @@
> > > +TODO:
> > > +
> > > +0. Functionality wise, everything works.
> > > +
> > > +1. Currently the plan is to add sysfs attributes for
> > > +	a. prux/load
> > > +	b. prux/unload
> > > +	c. prux/run
> > > +	d. prux/halt
> > > +   These will add to a more dynamic firmware management for the PRU.

> > Why sysfs?

[MW] Sysfs was discussed between Subhasish and Arnd in the following thread:
https://lkml.org/lkml/2011/5/5/137.  Arnd had recommended three options for loading a firmware-- the third of which involved sysfs.

> > > +
> > > +2. But, not sure how the fdt will effect these entries.
> > > +
> > > +Please send patches to Greg Kroah-Hartman <greg@kroah.com>.

> > Don't you want people to Cc: you as well?

> > I'm not going to adopt this driver, I have enough as it is :)


