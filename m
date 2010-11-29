Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0K2P0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:26:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:42871 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0K2P0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:26:22 -0500
Date: Mon, 29 Nov 2010 16:26:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@suse.com>,
        jmorris@namei.org, mjg@redhat.com
Subject: Re: [REGRESSION] Suspend fails because of TPM modules
In-Reply-To: <4CF3C547.6020302@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz>
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz> <4CF3C547.6020302@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Rajiv Andrade wrote:

> > > on my thinkpad x200s (and I have seen reports on different HW as well),
> > > suspend fails when TPM modules are loaded.
> > > 
> > > 	tpm_tis 00:0a: tpm_transmit: tpm_send: error -5
> > > 	legacy_suspend(): pnp_bus_suspend+0x0/0xa0 returns -5
> > > 	PM: Device 00:0a failed to suspend: error -5
> > > 	PM: Some devices failed to suspend
> > > 
> > > Once tpm, tpm_bios, tpm_tis and tpm modules are unloaded, suspend/resume
> > > works.
> > > 
> > > This is a regression. It definitely worked on this very same hardware on
> > > 2.6.34. Any kernel between .34 and .37 wasn't booted there, so I don't
> > > have any data of that kind.
> > > 
> > > I can try bisecting it, but if anyone sees immediately what the culprit
> > > might be, that'd be helpful.
> > I just found out, that if I modprobe tpm_tis module with
> > 
> > 	itpm=1
> > 
> > parameter, the problem doesn't happen any more and suspend works fine.
> > 
> > This definitely wasn't needed on older kernels though, so I'd consider
> > that still a regression.
> > 
> > Also, can't we make the module automatically detect the machines on which
> > to apply the workaround? Let's say, based on DMI?
> > 
> There's a patch already submitted that solves this:
> http://marc.info/?l=linux-kernel&m=128769741101534&w=2
> <http://marc.info/?l=linux-kernel&m=128769741101534&w=2>
> 
> This side effect (to solve the suspend issue) should increase its urgency I
> think.
> James, any thoughts?

Yeah, Matthew has already pointed me to that patch, thanks. I will be 
testing it shortly and providing my Tested-by: eventually.

Any ideas why other kernels were OK (.34) and didn't require this quirk on 
my machine at all?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
