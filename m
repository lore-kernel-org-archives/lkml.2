Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1HIJpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:45:31 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:39744 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab1HIJp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:45:29 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGjC0PECMV
X-RZG-CLASS-ID: mo00
Date: Tue, 9 Aug 2011 11:44:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 3/3] xen/pv-on-hvm kexec+kdump: reset PV
 devices in kexec or crash kernel
Message-ID: <20110809094443.GD7283@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
 <20110804162054.806626433@aepfle.de>
 <1312881788.26263.50.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1312881788.26263.50.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21.rev5535 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, Ian Campbell wrote:

> >  static int frontend_probe_and_watch(struct notifier_block *notifier,
> >  				   unsigned long event,
> >  				   void *data)
> >  {
> > +	/* reset devices in Connected or Closed state */
> > +	if (xen_hvm_domain())
>                                && reset_devices ??

No, reset_devices is passed as kernel cmdline option to a kdump boot.
But its not part of a kexec boot.

> How long should we wait for the backend to respond? Should we add a
> timeout and countdown similar to wait_for_devices?

Adding a timeout to catch a confused backend is a good idea. That would
give one at least a chance to poke around in a rescue shell.

> It's unfortunate that this code is effectively serialising on each
> device. It would be much preferable to kick off all the resets and then
> wait for them to occur. You could probably do this by incrementing a
> counter for each device you reset and decrementing it each time a watch
> triggers then wait for the counter to hit zero.

That feature needs more thought. Since xenbus_reset_state() is only
executed in the kexec/kdump case, the average use case is not slowed
down.

Olaf
