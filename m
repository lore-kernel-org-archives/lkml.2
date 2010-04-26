Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab0DZAAl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 20:00:41 -0400
Received: from THUNK.ORG ([69.25.196.29]:56278 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab0DZAAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 20:00:39 -0400
Date: Sun, 25 Apr 2010 20:00:25 -0400
From: tytso@mit.edu
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 5/9] PM: suspend_block: Add debugfs file
Message-ID: <20100426000025.GE667@thunk.org>
Mail-Followup-To: tytso@mit.edu, Randy Dunlap <randy.dunlap@oracle.com>,
	Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Len Brown <len.brown@intel.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
 <1271984938-13920-2-git-send-email-arve@android.com>
 <1271984938-13920-3-git-send-email-arve@android.com>
 <1271984938-13920-4-git-send-email-arve@android.com>
 <1271984938-13920-5-git-send-email-arve@android.com>
 <1271984938-13920-6-git-send-email-arve@android.com>
 <20100423135853.478af057.randy.dunlap@oracle.com>
 <20100425181517.GA22676@kroah.com>
 <4BD49D9D.7020004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD49D9D.7020004@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 12:53:01PM -0700, Randy Dunlap wrote:
> > It's debug-like information, and has more than one value per file, so
> > debugfs seems like the proper place for it.  I have no objection to it
> > going there.
> 
> I have no objection if it really is debug info, but I'm not convinced
> of that yet.

Well, I'll note right now we have a somewhat annoying gap.  If you
need to export multiple values such that they are consistent with each
other, what's the choice?  /proc, where some (but not all) kernel
developers will say, "eeeeeeviilllll".  /sys is explicitly for single
value per files only.  And then we have /debugfs, where some pendants
are kvetching about whether something is "really" debug information.

One of the things that we sometimes have to tell people who are trying
to navigate the maze of upstream submission is that sometimes you need
to know who to ignore, and that sometimes rules are guidelines
(despite pendants who will NACK based on rules like, "/proc,
eeeeewwww", or "/debugfs must only strictly be for debug information".

Telling embedded developers who only want to submit their driver that
they must create a whole new pseudo-filesystem just to export a single
file that in older, simpler times, would have just been thrown into
/proc is really not fair, and is precisely the sort of thing that may
cause them to say, "f*ck it, these is one too many flaming hoops to
jump through".  If we throw up too many barriers, in the long run it's
not actually doing Linux a service.

Sure, we need to make sure is code doesn't become a future burden, but
does a new file in /proc or something that might not _really_ be debug
information showing up in /debugfs really such a terrible thing in
terms of making the kernel less maintainable in the future?

Regards,

						- Ted
