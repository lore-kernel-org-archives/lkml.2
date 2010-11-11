Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab0KKUv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:51:26 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:54484 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab0KKUvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:51:25 -0500
Date: Thu, 11 Nov 2010 22:51:23 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [PATCHv6 0/7] system time changes notification
Message-ID: <20101111205123.GC10585@shisha.kicks-ass.net>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org>
 <22542.1289507293@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22542.1289507293@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 03:28:13PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 11 Nov 2010 21:29:55 +0200, Alexander Shishkin said:
> 
> > Consider we want stuff like "wakeup every day at 3pm", the next wakeup
> > might be earlier than the timer we calculated last time, on system
> > time changes. We need to re-calculate it. This is necessary for all
> > repeating events.
> > 
> > Say we want to wakeup at 3pm, now it's 4pm, so we schedule it in 23
> > hours. Now the system time changes to 2pm, and we would expect to
> > wakeup in one hour, but we take 25.
> 
> Sorry, I tuned in late here...
> 
> So the plan is that if you're not using this new interface, it will go off at
> the same absolute offset (23 hours after timer was set), but if you're using
> this interface, your timer event gets interrupted, you get woken up (say)
> 15 hours into your 23, and it's your job to decide if you need to set a
> new timer for the remaining 6, 7, 8 hours or some other number?

Yes. This interface doesn't deal with timers, it only provides notifications.

Regards,
--
Alex
