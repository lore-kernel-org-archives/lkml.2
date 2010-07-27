Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0G0RVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:21:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47048 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab0G0RVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:21:06 -0400
Date: Tue, 27 Jul 2010 18:21:00 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Run a dummy command before submitting a new
	command
Message-ID: <20100727172100.GC7324@srcf.ucam.org>
References: <1280246493-964-1-git-send-email-mjg@redhat.com> <4C4F123F.3010700@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F123F.3010700@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:07:11PM -0500, Corey Minyard wrote:
> I don't think this is the right way to handle the problem.  Though it's  
> not going to break anything, this change is just a hack.  We need to  
> figure out why these machine exhibit this behavior.  If it's a bug in  
> the driver, then we need to fix the driver.  If it's a bug in the HP  
> firmware, then we need to document it well as such, get HP to fix their  
> firmware, and possibly tie it into the xaction handler that's already in  
> start_next_msg.

Yeah, I agree that this isn't the optimal approach. I'm waiting to hear 
from HP if they have any idea what happened between 1.01 (which worked) 
and 1.05 (which is broken), which might give some more insight into what 
we're doing wrong.

> The only interaction with the device that this change should cause is  
> one read from the status register, since the device should be idle at  
> this point.  If that's the case, and it's not a driver bug, you can try  
> adding an xaction that calls smi_info->handlers->event(smi_info->si_sm, 
> 0).

I'll try to see what's going on.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
