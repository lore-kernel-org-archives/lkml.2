Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2JSPaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:30:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59494 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190Ab2JSPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:30:19 -0400
Date: Fri, 19 Oct 2012 16:30:15 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Randy Wright <rwright@hp.com>
Cc: linux-kernel@vger.kernel.org, Thavatchai Makphaibulchoke <tmac@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
Message-ID: <20121019153015.GD28212@srcf.ucam.org>
References: <jQZho-4fF-13@gated-at.bofh.it>
 <jSWfn-7B6-3@gated-at.bofh.it>
 <50816FC9.5080108@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50816FC9.5080108@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think DMI checking is going to work, since (a) as you say, 
there's a risk that the ID will inadvertantly change over the lifecycle 
of the machine, and (b) there may be other machines. So if it's not 
possible to handle this by catching the MCE, I think we have two 
options:

1) Declare that any x86 hardware supported by Linux *must* support 
probing in this address region

2) Don't call probe_roms() by default, but leave it up to the graphics 
drivers. If they can get the rom by any other means then don't call it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
