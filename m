Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1KARF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:05:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab1KARFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:05:24 -0400
Date: Tue, 1 Nov 2011 10:01:56 -0700
From: Greg KH <gregkh@suse.de>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Input: Remove unsafe device module references
Message-ID: <20111101170156.GA8925@suse.de>
References: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320162100-13494-1-git-send-email-dh.herrmann@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 04:41:40PM +0100, David Herrmann wrote:
> Hi Dmitry and Greg
> 
> It doesn't make sense to take a reference to our own module. When we call
> module_put(THIS_MODULE) we cannot make sure that our module is still alive when
> this function returns. Therefore, module_put() will return to invalid memory and
> our input_dev_release() function is no longer available.
> 
> It would be interesting if Greg could elaborate what else we could do to replace
> this module-refcount as it is definitely needed here. However, "struct device"
> doesn't provide an owner field so there is no way for us to let the device core
> keep a reference to our module.

For a bus module, yes, this is needed, so don't remove these calls, it's
wrong to do so.

> I have no clue what to do here but the current implementation is definitely
> unsafe so this is marked as RFC. Currently, the device_attributes probably
> already keep a reference to our module so applying this patch would probably not
> break anything, however, this does not look like something we can trust on.

Yes it is, why do you think it isn't?

> My bug-thread kind of died (https://lkml.org/lkml/2011/10/29/75) so I now try to
> show this with an example here.

It died due to me traveling, sorry, I'll respond to them now.

I fail to see what the real problem you are trying to solve here is.  Is
there something with the way the kernel works today that you are having
problems with?  What is driving this?


greg k-h
