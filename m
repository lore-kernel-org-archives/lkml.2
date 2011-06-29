Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1F2PXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:23:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48699 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755417Ab1F2PXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:23:12 -0400
Date: Wed, 29 Jun 2011 11:23:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
In-Reply-To: <20110629092001.GC10219@tugrik.mns.mnsspb.ru>
Message-ID: <Pine.LNX.4.44L0.1106291100360.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Kirill Smelkov wrote:

> > Apart from that one issue,
> > 
> > Acked-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thanks.
> 
> What should we do with this patch now? Should I put
> 
> 
>     Copyright (C) 2007 by Alan Stern
> 
> there? Or something else?

Yes, put that in.

> Or maybe drop that copyright notice altogether becase usually it gets
> outdated very quickly, and who made what is visible through git
> log/blame?

Copyright information is important, and it must be present in the 
actual file -- not somewhere else (such as a changelog).

> I'm ok with any case, please just tell me how to proceed.
> 
> 
> And what about main "[PATCH v2 2/2] USB: EHCI: Allow users to override
> 80% max periodic bandwidth"?
> 
> Was it Acked together with this one, or not and review is pending?
> Curious because I'm new here...

I haven't taken the time to review it yet, sorry...

Mostly it looks okay.  In store_uframe_periodic_max(), you can use 
kstrtouint() instead of sscanf() -- that seems to be the trend these 
days.

Also, when decreasing the schedule limit, do you think it is really 
necessary to check that the current allocation doesn't exceed the new 
limit?  I think it would be sufficient to apply the new limit just to 
new bandwidth allocation requests.  After all, this API is meant for 
experts only.

Alan Stern

