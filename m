Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab1GHVtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 17:49:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38617 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab1GHVtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 17:49:50 -0400
Date: Fri, 8 Jul 2011 22:49:41 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pstore dump inside an nmi handler
Message-ID: <20110708214941.GA20511@srcf.ucam.org>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:40:13PM -0700, Luck, Tony wrote:
> > Inside pstore_dump(), the first thing it tries to grab is a mutex_lock()
> > (inside an nmi hander).  This seems to be the root cause of my problems.
> 
> Someone else pointed out that mutex_lock() is a problem here too. They
> wondered whether spin_lock_irqsave() would work - or whether pstore
> backends were allowed to sleep - to which I said I hoped they didn't,
> but wasn't really sure what the future will hold.

EFI can't sleep (at least, not as far as the kernel's concerned), so 
we're safe there. I think it's fair to assume atomicity here - crash 
dumping is a pretty specific situation. Although we may need to think 
about whether pstore should be saving reboot and poweroff in that case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
