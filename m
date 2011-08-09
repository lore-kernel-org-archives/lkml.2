Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1HIL0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:26:37 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:4529 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab1HIL0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:26:36 -0400
X-IronPort-AV: E=Sophos;i="4.67,342,1309737600"; 
   d="scan'208";a="7175247"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/pv-on-hvm kexec+kdump: reset PV
 devices in kexec or crash kernel
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110809094443.GD7283@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
	 <20110804162054.806626433@aepfle.de>
	 <1312881788.26263.50.camel@zakaz.uk.xensource.com>
	 <20110809094443.GD7283@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Aug 2011 12:26:34 +0100
Message-ID: <1312889194.26263.107.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 10:44 +0100, Olaf Hering wrote:
> On Tue, Aug 09, Ian Campbell wrote:
> 
> > >  static int frontend_probe_and_watch(struct notifier_block *notifier,
> > >  				   unsigned long event,
> > >  				   void *data)
> > >  {
> > > +	/* reset devices in Connected or Closed state */
> > > +	if (xen_hvm_domain())
> >                                && reset_devices ??
> 
> No, reset_devices is passed as kernel cmdline option to a kdump boot.
> But its not part of a kexec boot.
> 
> > How long should we wait for the backend to respond? Should we add a
> > timeout and countdown similar to wait_for_devices?
> 
> Adding a timeout to catch a confused backend is a good idea. That would
> give one at least a chance to poke around in a rescue shell.
> 
> > It's unfortunate that this code is effectively serialising on each
> > device. It would be much preferable to kick off all the resets and then
> > wait for them to occur. You could probably do this by incrementing a
> > counter for each device you reset and decrementing it each time a watch
> > triggers then wait for the counter to hit zero.
> 
> That feature needs more thought. Since xenbus_reset_state() is only
> executed in the kexec/kdump case, the average use case is not slowed
> down.

I was thinking more of avoiding slowing down the kexec/kdump case
unnecessarily.

Ian.
> 
> Olaf


