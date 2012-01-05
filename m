Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab2AEUQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:16:51 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:38115 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932707Ab2AEUQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:16:49 -0500
X-Sasl-enc: j+7kiNSKMgZcH/PLdUu7OdifWWFN08QSRatcVZtzn1Mj 1325794608
Date: Thu, 5 Jan 2012 12:14:18 -0800
From: Greg KH <greg@kroah.com>
To: Thilo-Alexander Ginkel <thilo@ginkel.com>
Cc: oliver@neukum.name, gregkh@suse.de, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb: cdc-acm: Fix acm_tty_hangup() vs.
 acm_tty_close() race
Message-ID: <20120105201418.GA32610@kroah.com>
References: <1324115710-14756-1-git-send-email-thilo@ginkel.com>
 <CANvSZQ_y6uZSGgF28+AH+se-ecg+sHhy6pzo7++YvqtArHsUMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANvSZQ_y6uZSGgF28+AH+se-ecg+sHhy6pzo7++YvqtArHsUMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 10:43:09PM +0100, Thilo-Alexander Ginkel wrote:
> Hi there,
> 
> On Sat, Dec 17, 2011 at 10:55, Thilo-Alexander Ginkel <thilo@ginkel.com> wrote:
> > There is a race condition involving acm_tty_hangup() and acm_tty_close() where
> > hangup() would attempt to access tty->driver_data without proper locking and
> > NULL checking after close() has potentially already set it to NULL.
> > One possibility to (sporadically) trigger this behavior is to perform a
> > suspend/resume cycle with a running WWAN data connection.
> >
> > This patch addresses the issue by introducing a NULL check for
> > tty->driver_data in acm_tty_hangup() protected by open_mutex and exiting
> > gracefully when hangup() is invoked on a device that has already been closed.
> 
> just wondering: Is there any chance that this patch will make it into
> 3.3? I would really appreciate that as the bug it fixes is pretty
> annoying (and potentially causes data loss when the laptop locks up on
> resume) and I am sure that I am not the only one affected by it (at
> least all Lenovo T420s with an Ericsson F5521gw WWAN modem should be
> similarly affected).
> 
> If you would like to see any changes to the code or commit message
> before considering the patch for inclusion, please let me know.

As this isn't going to be an issue with 3.3 (from what I can tell, the
code is correctly reworked in the patch set queued up for 3.3), I'll
submit this for only the 3.2 and older kernel -stable releases, as that
is the only place this should be relevant for.

thanks,

greg k-h
