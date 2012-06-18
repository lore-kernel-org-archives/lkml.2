Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2FRMc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:32:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43601 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2FRMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:32:25 -0400
Date: Mon, 18 Jun 2012 14:32:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bojan Smojver <bojan@rexursive.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120618123205.GA5319@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Alan Stern <stern@rowland.harvard.edu>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
 <20120616230706.GA26955@liondog.tnic>
 <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
 <201206172221.55493.rjw@sisk.pl>
 <1339979586.1666.13.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1339979586.1666.13.camel@shrek.rexursive.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 10:33:06AM +1000, Bojan Smojver wrote:
> On Sun, 2012-06-17 at 22:21 +0200, Rafael J. Wysocki wrote:
> > Yeah, that will do.
> 
> Something like this maybe. I didn't really test this, so Borislav,
> please let me know whether this is something that may works for you.

Yeah, this could probably work but it changes the progress indicator
unconditionally.

I don't know what the general consensus is about the progress indicator
but if you want to keep the old behavior too, you probably need to carve
out the printk functionality from save_image() and pass flags to the new
function which printks different output depending on how it is.

If we don't want the current output with how many pages it needs to use
on swap, then we can do the dots.

Frankly, I don't have a preference.

Hmm.

-- 
Regards/Gruss,
Boris.
