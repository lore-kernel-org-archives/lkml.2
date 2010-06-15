Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab0FORsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:48:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab0FORsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:48:31 -0400
Date: Tue, 15 Jun 2010 10:47:42 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       khali@linux-fr.org
Subject: Re: [PATCH 12/12] usb: use IRQ watching
Message-ID: <20100615174742.GA21616@suse.de>
References: <1276443098-20653-1-git-send-email-tj@kernel.org>
 <1276443098-20653-13-git-send-email-tj@kernel.org>
 <20100614214122.GA21064@suse.de>
 <4C16A48A.2070404@kernel.org>
 <4C16AAEE.5090204@kernel.org>
 <AANLkTilG1KAVOe5DcpLEFAJ-37PQJCgVT-jLZhr1e6tC@mail.gmail.com>
 <4C176206.90305@kernel.org>
 <AANLkTinVL4UuF70E1dR1vbYYkVRTBDh5su5D9k0h-vVA@mail.gmail.com>
 <4C17BA0C.4010208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C17BA0C.4010208@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 07:36:12PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/15/2010 03:36 PM, Kay Sievers wrote:
> > Yeah, I'm pretty sure that's not what we want. We want structured
> > data, and a generic channel to pass all sort of errors through, and a
> > userspace part to handle it in a sane way. Many error sources may also
> > not have a device path in /sys, and therefore no uevent to send.
> > Uevents/udev just seem so convinient because it's already there, but I
> > think, has too many limitations to provide the needed functionality.
> > Besides the fact that nothing listens to these events in userspace
> > today -- it's a lot more to think through and work on than passing
> > things through uevents, especially some generic classification and
> > structured data passing, which is needed, instead of the current
> > free-text 'dmsg' or the property-based stuff in uevents. I'm very sure
> > it's the wrong facility to use.
> 
> Yeah, well, if you say so.  It would be very nice to have report this
> type of critical events in somewhat formatted way so that they can be
> processed automatically and presented to the user in more accessible
> manner.  I doubt requiring strict structure would work in the long
> run.  It'll likely end up being able to cover only portion of what's
> originally designed and and stagnate in time.  I think control
> information including identification and severity + free form string
> would be much more manageable.
> 
> It would really be great to have something like that.  I can easily
> think of several libata events the user should be notified of from the
> top of my head but currently are buried in dmesg.

That is what Andi Kleen and others are working on at the moment.  I
think he's posted to lkml about it, and there are going to be more talks
about it at the Plumbers conference this year.

thanks,

greg k-h
