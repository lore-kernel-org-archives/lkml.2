Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1HAFrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:47:40 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:58385 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1HAFrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:47:36 -0400
Date: Mon, 01 Aug 2011 01:47:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mrst_pmu: driver for Intel Moorestown Power Management Unit
In-reply-to: <20110713105105.63e2fbcb@lxorguk.ukuu.org.uk>
Message-id: <alpine.LFD.2.02.1108010135290.26733@x980>
References: <alpine.LFD.2.02.1107122328180.4502@x980>
 <20110713105105.63e2fbcb@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static struct mrst_device *pci_id_2_mrst_dev(u16 pci_dev_num)
> > +{
...
> > +	else
> > +		BUG();
> > +
> > +	BUG_ON(pci_dev_num != mrst_devs[index].pci_dev_num);
> 
> That strikes me as needlessly unfriendly, you could warn/return NULL and
> propogate a WARN_ONCE back to the user.

This code asserts that the firmware is correct, and today it is.
If somebody breaks the firmware in the future, I want them to discover
it the instant they break it.  If I had the option of shooting
lazer beams out of the system to instantly kill the firmware programmer,
I'd do it.  But alas, I have to settle for crashing their system:-)

> > +static int __init scu_fw_check(void)

	if (!mrst_pmu)
		return 0;

> > +late_initcall(scu_fw_check);
> 
> NAK. I pointed this problem with the driver to you way back - this code
> gets run always - even on machines that are not in fact Moorestown which
> are then going to crash.
> 
> You need to check that the platform is Moorestown (not just the CPU
> either because of Oaktrail)

Right-o.  I think the 1-liner to check mrst_pmu above should do it.

thanks for reading, and sorry for being a slow listener,
-Len

