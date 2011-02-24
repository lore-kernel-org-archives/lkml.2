Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab1BXAn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:43:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33913 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab1BXAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:43:54 -0500
Date: Thu, 24 Feb 2011 00:43:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: btusb autosuspend (was Re: Linux 2.6.38-rc6)
Message-ID: <20110224004333.GA22698@srcf.ucam.org>
References: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTzjHkVQGPBRXrcb6M1_xaDY_==pB5ZyB9CJpR@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 04:25:23PM -0800, Linus Torvalds wrote:
> Hmm. Is there any reason we shouldn't revert commit
> 556ea928f78a390fe16ae584e6433dff304d3014 given the regression?

I think reverting makes sense at the moment. I haven't seen the reported 
issues - I need to figure out if this is related to bus powered/self 
powered devices, or what else is causing the difference.

> It apparently had problems before too, and caused autosuspend to be
> disabled entirely, judging at least by
> 
>   https://bugzilla.redhat.com/show_bug.cgi?id=528744
> 
> but there's obviously the comment about "those should be fixed now".
> Apparently there are more issues.

Right, we were autosuspending even when there were active connections. 
Marcel told me that ought to be fixed and my testing seemed to agree...

> I have no idea whether this is a USB-level issue, or a driver-level
> one. There are no comments about exactly what fixed the input device
> issues. So I'm adding both BT and USB people to the discussion.

I'll try to get time to look at this this week. Marcel, any ideas?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
