Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab2ELScu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 14:32:50 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57868 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2ELScr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 14:32:47 -0400
Date: Sat, 12 May 2012 14:22:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>, David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-05-04
Message-ID: <20120512182227.GA30574@tuxdriver.com>
References: <20120505001243.GC23728@joana>
 <20120508070211.GB11843@joana>
 <20120511201620.GD7620@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511201620.GD7620@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 05:16:20PM -0300, Gustavo Padovan wrote:
> Hi Dave,
> 
> I couldn't get this pull by John this week, he's been unresponsive.
> We would love to see this code in the 3.4 kernel (not sure if this would be
> possible if Linus do not release the -rc7, there are important fixes 
> in the pull request, such as a fix to a regression that was breaking bluetooth
> keyboards.
> 
> Please let me know if you have any problems with this! I checked this code for
> coding style issues too. Thanks.

Well, I do apologize for my lack of responsiveness.  My employer saw
fit to have me (figuratively) locked in a room with no email access all
week, with me getting home rather late in the evenings and returning
early each morning.  I would have liked to have stayed awake for
hours each night catching-up, but I just didn't have the strength. :-(

With that said, I'm not at all sure that this batch of fixes is
appropriate for this late in the release cycle.  Normally at this
point I would expect to see "regression cause by commit 1234" or
"this common action results in this crash", all fixed by one-liners
wherever possible.  This batch is more like "causes some problems",
or "needs to be different" -- neither of which sound urgent enough
to be worth requesting delays in Linus's release schedule.

I am still quite exhausted from the past week, so it is possible that I
am overlooking the importance of some of these commits.  But for right
now, I am not convinced that there needs to be a rush on this request.
Dave can do as he sees fit, of course.

John

> 	Gustavo
> 
> * Gustavo Padovan <gustavo@padovan.org> [2012-05-08 04:07:54 -0300]:
> 
> > Hi John,
> > 
> > * Gustavo Padovan <gustavo@padovan.org> [2012-05-04 21:12:43 -0300]:
> > 
> > > Hi John,
> > > 
> > > A few more patch to 3.4. There is 3 fixes from Mat Martineau, a fix for
> > > a incoming MTU check that was breaking ERTM, still on ERTM there is a
> > > patch that fixes concurrency with one of our locks. His third patch is
> > > related to lock fixes too.
> > > Besides that Johan fixed a wrong bit set in the Inquiry code, Vishal
> > > Agarwal added a EIR fix and finally we have support for one more usb id.
> > > 
> > > Please pull or let me know of any problems!
> > 
> > I saw that you didn't pull this yet, so I decided to re-do this pull request.
> > We have more 3 important fixes to go in. They fix a regression that was
> > preventing Bluetooth keyboard to work. I'll re-do the whole pull request
> > message, so you can copy and paste it easily:
> > 
> > A few more patch to 3.4. There is 3 fixes from Mat Martineau, a fix for a
> > incoming MTU check that was breaking ERTM, still on ERTM there is a patch that
> > fixes concurrency with one of our locks. His third patch is related to lock
> > fixes too.
> > Besides that Johan fixed a wrong bit set in the Inquiry code, Vishal Agarwal
> > added a EIR fix and finally we have support for one more usb id.  Finally
> > Johan and I fixed a regression that was preventing bluetooth keyboard to work.
> > 
> > Please pull or let me know of any problems!
> > 
> > 	Gustavo
> > 
> > ---
> > 
> > The following changes since commit 985140369be1e886754d8ac0375dd64e4f727311:
> > 
> >   Add Foxconn / Hon Hai IDs for btusb module (2012-04-24 11:38:41 -0300)
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream
> > 
> > for you to fetch changes up to fbcb6a061652b38257a1d8bcf6ebd70fc1771549:
> > 
> >   Bluetooth: mgmt: Fix device_connected sending order (2012-05-07 20:56:30 +0300)
> > 
> > ----------------------------------------------------------------
> > Gustavo Padovan (2):
> >       Bluetooth: notify userspace of security level change
> >       Bluetooth: report the right security level in getsockopt
> > 
> > Johan Hedberg (2):
> >       Bluetooth: Fix Inquiry with RSSI event mask
> >       Bluetooth: mgmt: Fix device_connected sending order
> > 
> > Mat Martineau (3):
> >       Bluetooth: Fix a redundant and problematic incoming MTU check
> >       Bluetooth: Restore locking semantics when looking up L2CAP channels
> >       Bluetooth: Lock the L2CAP channel when sending
> > 
> > Michael Gruetzner (1):
> >       bluetooth: Add support for Foxconn/Hon Hai AR5BBU22 0489:E03C
> > 
> > Vishal Agarwal (1):
> >       Bluetooth: Fix EIR data generation for mgmt_device_found
> > 
> >  drivers/bluetooth/ath3k.c         |    6 ++++++
> >  drivers/bluetooth/btusb.c         |    3 +++
> >  include/net/bluetooth/bluetooth.h |    3 +--
> >  include/net/bluetooth/hci_core.h  |   17 +++++++++++++++++
> >  net/bluetooth/af_bluetooth.c      |    2 +-
> >  net/bluetooth/hci_core.c          |    8 ++++++++
> >  net/bluetooth/hci_event.c         |   17 +++++++++++++----
> >  net/bluetooth/l2cap_core.c        |   35 ++++++++---------------------------
> >  net/bluetooth/l2cap_sock.c        |   39 +++++++++++++++++++++++++--------------
> >  9 files changed, 82 insertions(+), 48 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
