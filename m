Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab2LCHnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:43:24 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59841 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2LCHnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:43:22 -0500
Date: Sun, 2 Dec 2012 23:43:18 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Moeller <kode54@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Input: xpad - Implement wireless controller LED
 setting and fix connect time LED setting
Message-ID: <20121203074318.GC28682@core.coreip.homeip.net>
References: <20121130135406.38c9bdc9@umaro.lan>
 <1994333.0mnJMZMWGT@dtor-d630.eng.vmware.com>
 <20121130201329.3f8aefa0@umaro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130201329.3f8aefa0@umaro.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 08:13:29PM -0800, Chris Moeller wrote:
> On Fri, 30 Nov 2012 14:30:23 -0800
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > Hi Chris,
> > 
> > On Friday, November 30, 2012 01:54:06 PM Chris Moeller wrote:
> > > I've submitted versions of this with prior patch sets, and this part
> > > was never accepted, possibly because it depended on other patches to
> > > work, or possibly because it wasn't so cleanly organized. This time,
> > > I've split the LED setting command off into its own static function,
> > > then call that on controller connect and optionally on LED setting
> > > commands. The static function does not include any locking, because
> > > locking inside the function which receives the incoming packets
> > > deadlocks the driver, and does not appear to be necessary anyway.
> > > 
> > > It also removes all traces of the original bulk out function which
> > > was designed for the purpose of setting the LED status on connect,
> > > as I found that it actually does not work at all. It appears to try
> > > to send the data, but nothing actually happens to the controller
> > > LEDs.
> > 
> > Attached is a reply I sent to on 7/4/11 to which you unfortunately
> > never responded. The issue is that of force feedback (rumble) and LED
> > share the same URB then access to that URB should be arbitrated. The
> > attached message contains a patch that attempts to implement that
> > arbitration, could you please try it out and see what changes are
> > needed to make it work?
> > 
> > Thanks.
> > 
> 
> So sorry I missed your reply. That's what I get for filtering the
> mailing list messages past my inbox, then never following up on my
> filter/folder set for replies to my own messages. I recall you
> mentioned that potential race condition when I first submitted, but I
> forgot to do anything about it. I'm glad at least one of us has our
> stuff together. It seems to work just fine, but there may be a force
> feedback issue with the following test program, where it leaves the
> effect playing indefinitely after the program terminates, and then the
> controller itself ceases to respond until the module is removed and
> reloaded.

Just to confirm, you see this problem only with the patch being
discussed and do not see it without it, right?

-- 
Dmitry
