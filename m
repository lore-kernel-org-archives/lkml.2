Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2EYPe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:34:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33438 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EYPeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:34:25 -0400
Date: Fri, 25 May 2012 16:34:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120525153416.GA16973@srcf.ucam.org>
References: <4FBFBF5F020000780008637F@nat28.tlf.novell.com>
 <20120525152414.GA16704@srcf.ucam.org>
 <4FBFC1A3020000780008638F@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBFC1A3020000780008638F@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 04:30:11PM +0100, Jan Beulich wrote:
> >>> On 25.05.12 at 17:24, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Looks good, but should we also be changing get_time to return in UTC? 
> 
> Imo that would be a separate change though.

Sure, but probably a useful one. I've had complaints from firmware 
vendors that we're not handling the timezone properly here.

> > What are the expected semantics for get_wallclock?
> 
> Not sure - I think both are permitted (just like for the legacy RTC),
> with the expectation that early user mode would tell the kernel.

Yeah. I think get_time and set_time should probably both be paying 
attention to sys_tz and converting appropriately.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
