Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2JWAKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:10:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45112 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab2JWAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:10:32 -0400
Date: Tue, 23 Oct 2012 01:10:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minyard@acm.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 2/5] ACPI: Reorder IPMI driver before any other ACPI
 drivers
Message-ID: <20121023001028.GB11756@srcf.ucam.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
 <1350420820-7156-3-git-send-email-minyard@acm.org>
 <20121022164538.3b707397.akpm@linux-foundation.org>
 <20121023000033.GA11756@srcf.ucam.org>
 <20121022170703.03a11f39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022170703.03a11f39.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 05:07:03PM -0700, Andrew Morton wrote:
> On Tue, 23 Oct 2012 01:00:34 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Not really - some of this code can be built as modules, so it's mostly 
> > module_init rather than anything from the initcall family.
> > 
> 
> hm.  So the ACPI code has found a way to defeat depmod? 

We don't express dependencies between available operation regions and 
the code that supports them. Most are set up in the core ACPI code and 
so the problem is avoided, but the IPMI code is a separate chunk.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
