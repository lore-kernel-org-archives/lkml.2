Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1FGSlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:41:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50357 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750899Ab1FGSlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:41:46 -0400
Date: Tue, 7 Jun 2011 14:41:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v15 10/10] usb:dummy_hcd: Force FS device connection
 according to module parameter
In-Reply-To: <016d01cc2541$0bfa5980$23ef0c80$@org>
Message-ID: <Pine.LNX.4.44L0.1106071436020.1972-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Tanya Brokhman wrote:

> > > I thought about that as well. Even added it but removed at the last
> > minute
> > > :) I encountered quite a few places in the code where some error
> > message to
> > > the user is really needed but is missing
> > 
> > What other places?  There is very little the user has to do with
> > dummy-hcd -- really nothing more than setting the module parameters.
> 
> I'm not talking about dummy_hcd. It was a general comment about the gadget
> code. I can't give you an example from the top of my head...

Oh.  Well, if you're writing new code and you come across a place where 
an error message really is needed, you should add the error message.

> > IMO the driver should print an error message and fail to load if there
> > are contradictory module parameters.
> > 
> 
> Well, I can add the error message but I think that as far as dummy_hcd is
> concerned failing it's loading is a bit harsh, isn't it? I mean, this is a
> type of user error that can be fixed so why not fix it and just notify the
> user of what was done?

But if the parameters are contradictory, you don't know _how_ to fix 
it.  If is_super_speed is True and is_high_speed is False, did the user 
want to add SuperSpeed support or to remove high-speed support?

Besides, the best (i.e., easiest and most likely to be correct) way of
fixing the error is for the user to issue the modprobe command again,
with the correct parameters this time.  Therefore the driver should
fail to load, so that the modprobe can be reissued with no need to do
rmmod first.

Alan Stern

