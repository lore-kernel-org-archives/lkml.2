Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2LDUbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2LDUbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:31:47 -0500
Date: Tue, 4 Dec 2012 18:31:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Ortiz, Lance E" <lance.oritz@hp.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] aerdrv: Enhanced AER logging
Message-ID: <20121204183110.3de876de@redhat.com>
In-Reply-To: <A961433CDFF2F640A2866803152E61F9516EEACD@G4W3218.americas.hpqcorp.net>
References: <20121204170429.31397.50068.stgit@grignak.americas.hpqcorp.net>
	<20121204170436.31397.40857.stgit@grignak.americas.hpqcorp.net>
	<20121204164151.66b9bb37@redhat.com>
	<A961433CDFF2F640A2866803152E61F9516EEACD@G4W3218.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Dec 2012 20:14:10 +0000
"Ortiz, Lance E" <lance.oritz@hp.com> escreveu:

> > > +	if (!dev) {
> > > +		pr_info("PCI AER Cannot get PCI device
> > %04x:%02x:%02x.%d\n",
> > > +			pcie->device_id.segment, pcie->device_id.bus,
> > > +			pcie->device_id.slot, pcie->device_id.function);
> > 
> > Hmm... please correct if I'm wrong, but an error happened at PCI, and
> > also a
> > kernel bug that prevented it to get the proper PCI device...
> > 
> > IMHO, the message here should be stronger, and likely printed via
> > pr_err().
> > 
> 
> Mauro,
> 
> I modeled this message after other places in the kernel where this function failed.  So I figured it would be safe to be consistent there.  I agree though that it should be pr_err().  I can make that change.

I understand. On most cases, this may not be a critical issue.

However, in this particular case, if PCI AER got an error, but the device
is not found when trying to handle it, it can be an indication that 
the PCI device has a more serious issue. So, I'm in favor of changing it,
and likely be more verbose at the error message, saying that the device
was not found while trying to report an error condition that happened
there. It could make sense to even send a trace for the daemon to be
aware of the error, on some pci device that vanished likely due to the
error.

Regards,
Mauro
