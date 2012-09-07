Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2IGUxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:53:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab2IGUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:53:13 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: balbi@ti.com
Cc: Greg KH <gregkh@linuxfoundation.org>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-serial@vger.kernel.org, Sourav Poddar <sourav.poddar@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        alan@linux.intel.com
Subject: Re: [PATCH v4 00/21] OMAP UART Patches
Organization: Deep Root Systems, LLC
References: <20120906122948.GC29202@arwen.pp.htv.fi>
	<1346935540-1792-1-git-send-email-balbi@ti.com>
	<87harahiv6.fsf@deeprootsystems.com>
	<20120907054932.GB3136@arwen.pp.htv.fi>
Date: Fri, 07 Sep 2012 13:53:11 -0700
In-Reply-To: <20120907054932.GB3136@arwen.pp.htv.fi> (Felipe Balbi's message
	of "Fri, 7 Sep 2012 08:49:34 +0300")
Message-ID: <87oblhmu6g.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <balbi@ti.com> writes:

> Hi,
>
> On Thu, Sep 06, 2012 at 03:44:13PM -0700, Kevin Hilman wrote:
>> Felipe Balbi <balbi@ti.com> writes:
>> 
>> > Hi guys,
>> >
>> > here's v4 of the omap uart patchset. No changes other than a rebase on top of
>> > Greg's tty-next branch and Tony's Acked-by being added to a couple patches
>> >
>> > Note: I'm resending the series with Vikram's Software Flow Control fix anyway
>> > as it can just be ignored if it's decided it needs to go into this merge
>> > window.
>> 
>> Sorry to be late to the party... just getting back from some time off.
>> 
>> I'm assuming that this was not tested with PM, so decided I better do it
>
> you assumed wrong. See the previous versions of the series and you'll
> see I mention all the basic pm testing I did.

My apologies for not reading the previous versions.  I don't think it's
unusual that a reviewer should expect everything he to know about a
series (including how it was tested) is in the cover letter or in the
changelogs of the latest series.  I don't expect to have to look through
all the previous versions for this kind of info.  Since I wasn't around
to review/test the earlier versions, I just looked at the latest (v4)
and didn't see any mention of testing of any sort in the cover letter.

Looking back at the previous cover letters, I don't see any description
of the PM testing either.  I only see it was tested on pandaboard.
Since mainline doesn't have full PM support for OMAP4, testing on panda
doesn't really test UART PM at all.

Could you please point me to the descriptions in earlier mails of how
you did PM testing, and on what platforms?

In addition, IMO, if this was only tested on Panda (as suggested by
earlier cover letters), it really should not have been merged until it
got some broader testing.

>> myself seeing that Greg is has already merge it.  To test, I merged
>> Greg's tty-next branch with v3.6-rc4 and did some PM testing.
>> 
>> The bad news is that it doesn't even compile (see reply to [PATCH v4
>> 20/21]).  
>
> yeah, that was an automerge issue when rebasing on greg's tty-next
> branch, plus me assuming omap serial was already enabled on my .config
> and not checking the compile output. Sent a patch now.

As I reported in my reply to [PATCH v4 20/21], that patch also had
another problem where it introduced a new (but unused) field.  Maybe
another rebase problem?  I see the same problem in v3 and v4.

>> Also, there is a big WARNING on boot[1], which seems to be triggered by
>> a new check added for v3.6-rc3[2].  This appears to be introduced by
>> $SUBJECT series, because I don't see it on vanilla v3.6-rc4.

[...]

> This doesn't seem to be caused by $SUBJECT at all. See that we are
> calling uart_add_one_port() which will call tty_port_register_device()
> which, in turn, will call tty_port_link_device() and that will set
> driver->ports[index] correctly.
>
> Have you checked if this doesn't happen without my series before waving
> your blame hammer ? FWIW, that part of the code wasn't change by
> $SUBJECT at all.

Whoa.  This was only test report.  No need to get personal.  All I said
is that it "seemed" to introduced by $SUBJECT series.  Hardly waiving
"blame hammer."

And yes, I did check without your series.  As I reported above, the
warning didn't exist with v3.6-rc4, and it did with yesterday's tty-next
branch.  The WARNING pointed a finger at ttyO (omap-serial) so I assumed
it was in $SUBJECT series.

Testing with todays tty-next, the problem is gone.  The patch
'tty_register_device_attr updated for tty-next'[1] seems to have made
the problem go away.  So it's now clear that it wasn't introduced by
$SUBJECT series.   My bad.

Yesterday, it wasn't that obvious, so I made an assumption in order to
report a problem uncovered in my testing in the hopes that it would be
helpful to you in fixing a potential problem. My assumption was wrong, I
was wrong.  I'm wrong a lot, and I'm OK with that. The bug was
elsewhere, and is already fixed.

My apologies if it seemed like I was blaming you.

Kevin

[1] 
Author: Tomas Hlavacek <tmshlvck@gmail.com>  2012-09-06 14:17:47
Committer: Greg Kroah-Hartman <gregkh@linuxfoundation.org>  2012-09-06 14:40:18
Parent: 6915c0e487c822e2436683e14302c0b8a6155cc7 (tty: uartclk value from serial_core exposed to sysfs)
Child:  e36851d0fa94b0f7802b3cc80406dbd3ef4f2f16 (serial: omap: fix compile breakage)
Branch: tmp/uart-test-2
Follows: v3.6-rc3
Precedes: 

    tty_register_device_attr updated for tty-next
    
    Added tty_device_create_release() and bound to dev->release in
    tty_register_device_attr().
    Added tty_port_register_device_attr() and used in uart_add_one_port()
    instead of tty_register_device_attr().
    
    Signed-off-by: Tomas Hlavacek <tmshlvck@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

