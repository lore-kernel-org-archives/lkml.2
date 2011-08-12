Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1HLR7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 13:59:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33184 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1HLR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 13:59:17 -0400
Date: Fri, 12 Aug 2011 18:59:12 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: Re: pstore: change mutex locking to spin_locks
Message-ID: <20110812175912.GA16704@srcf.ucam.org>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:54:51AM -0700, Luck, Tony wrote:
> From: Don Zickus <dzickus@redhat.com>
> 
> pstore was using mutex locking to protect read/write access to the
> backend plug-ins.  This causes problems when pstore is executed in
> an NMI context through panic() -> kmsg_dump().
> 
> This patch changes the mutex to a spin_lock_irqsave then also checks to
> see if we are in an NMI context.  If we are in an NMI and can't get the
> lock, just print a message stating that and blow by the locking.
> 
> All this is probably a hack around the bigger locking problem but it
> solves my current situation of trying to sleep in an NMI context.
> 
> Tested by loading the lkdtm module and executing a HARDLOCKUP which
> will cause the machine to panic inside the nmi handler.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
