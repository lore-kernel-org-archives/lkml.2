Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab2GJPJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:09:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58713 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753000Ab2GJPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:09:43 -0400
Date: Tue, 10 Jul 2012 11:09:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] usb: host: Fix possible kernel crash
In-Reply-To: <4FFBAEFF.5060407@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1207101108060.1308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012, Venu Byravarasu wrote:

> Thanks Alan for your comments.
> 
> On Monday 09 July 2012 08:04 PM, Alan Stern wrote:
> > On Mon, 9 Jul 2012, Venu Byravarasu wrote:
> >
> >> In functions itd_complete &  sitd_complete, a pointer
> >> by name stream may get dereferenced after freeing it, when
> >> iso_stream_put is called with stream->refcount = 2.
> > I don't understand the problem.  Did you actually see this happen or is
> > it only theoretical?
> 
> Yes it is a theoretical problem, as complained by Coverity.

> As per the logic you explained above, this change is not needed.
> However coverity was complaining as below:
> 
> /kernel/drivers/usb/host/ehci-sched.c 1777 USE_AFTER_FREE Dereferencing 
> freed pointer "stream"
> 
> Hence to pacify coverity, this change is done.
> Please let me know if you see any other better way to handle it.

This seems to be a false positive from Coverity.

In any case, I'm about to submit some patches which get rid of the 
reference counting entirely.  So let's not worry about this.

Alan Stern

