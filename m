Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887Ab2GLOGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab2GLOGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:06:00 -0400
Date: Thu, 12 Jul 2012 10:05:52 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
Message-ID: <20120712140552.GA13745@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Kay Sievers <kay@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartmann <greg@kroah.com>
References: <20120709180328.GA4105@redhat.com>
 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
 <1341859731.801.0.camel@mop>
 <20120712005405.GA1613@redhat.com>
 <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13J98an3GW1-aBOEk=5Vyr+is1DaPhz-UFWHBOJ2nHkKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 03:52:17PM +0200, Kay Sievers wrote:
 > On Thu, Jul 12, 2012 at 2:54 AM, Dave Jones <davej@redhat.com> wrote:
 > > On Mon, Jul 09, 2012 at 08:48:51PM +0200, Kay Sievers wrote:
 > 
 > >  > It looks fine here with the above mentioned patch:
 > >
 > > Now that that patch is in Linus tree, I've hit what's probably a different case.
 > > Look at the modules list in this oops..
 > >
 > > [10016.460020] BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child1:24295]
 > > [10016.470008]  rose<4>[10016.470008]  ip_set_bitmap_ipmac<4>[10016.470008]
 > 
 > > Also, I have no idea how the hell the 'Modules linked in:' line (9th line) ended up being printed /after/ the
 > > module listing began (2nd line).
 > 
 > It's the output of 'dmesg' you pasted, right?

Yes.

 > I tried to force all sorts of racy print_modules() calls, and kept
 > your trinity tool from git for hours, it looks all fine here:
 > 
 > Can you easily reproduce the issue you pasted?  If, could you give me
 > the /dev/kmsg output?

I've seen it a few times, always with the soft lockup trace.

You might be able to trigger it using scripts/load-all-modules.sh
from trinity.git. (Assuming you have a lot of modules built, I'm
still trying to track down which one seems to be responsible).

	Dave

