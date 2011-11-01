Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1KASBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 14:01:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab1KASBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 14:01:45 -0400
Date: Tue, 1 Nov 2011 10:58:43 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@googlemail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: Remove unsafe device module references
Message-ID: <20111101175843.GA4241@suse.de>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
 <20111101170156.GA8925@suse.de>
 <20111101175210.GA15216@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101175210.GA15216@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 10:52:10AM -0700, Dmitry Torokhov wrote:
> On Tue, Nov 01, 2011 at 10:01:56AM -0700, Greg KH wrote:
> > On Tue, Nov 01, 2011 at 04:41:40PM +0100, David Herrmann wrote:
> > > Hi Dmitry and Greg
> > > 
> > > It doesn't make sense to take a reference to our own module. When we call
> > > module_put(THIS_MODULE) we cannot make sure that our module is still alive when
> > > this function returns. Therefore, module_put() will return to invalid memory and
> > > our input_dev_release() function is no longer available.
> > > 
> > > It would be interesting if Greg could elaborate what else we could do to replace
> > > this module-refcount as it is definitely needed here. However, "struct device"
> > > doesn't provide an owner field so there is no way for us to let the device core
> > > keep a reference to our module.
> > 
> > For a bus module, yes, this is needed, so don't remove these calls, it's
> > wrong to do so.
> 
> Strictly speaking, David is right, there is a race condition here.
> However since we do module_put() as very last operation of
> input_dev_release() it is extremely hard to trigger this race.
> 
> Until we have a better way of pinning the bus (or class) implementation
> in memory we should keep __module_get/module_put in input core.

I agree, that's fine for a bus to do, as long as you are aware of how it
is working.

greg k-h
