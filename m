Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0FLCoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:44:00 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:30870 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752197Ab0FLCn6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:43:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 597214.18207.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=omDOZqKIHeEdhSbBmA11b0ROrtYfWFo7r7t9olcwlm+IdTAmkh93iBDx3l9QF7OHJsNioaXXW/ZgHejLkMYBLPGPq+Udmu+ZNh3oAK+vtk6DxVRXx/8/TblniMRTsSM7qikM5jPyvhurPCmR7gm6H9DnO2EeFtJ3ssvpZQaA1WI=;
Message-ID: <436654.19077.qm@web180311.mail.gq1.yahoo.com>
X-YMail-OSG: PJWUJCMVM1m1l9IX2QfV2z7LDi3On_UFuTZ3YuC2R5rRmdS
 vdGBkW.Z5bjmZ6rBphiaSLq6bLgrDpigWImaePqrBakURTFv2PDQ_vDoUF4Q
 FpoGM.WIoLOd8.6c6zTpn4m.FJLdHcpXRi60rDLXhNIZR5Id7Wfje3lMlPgP
 DF08YNJL2y1ojL6yRr.IinVwqUupsJ0w9hsC.7DBagFwd2JTo3pUySn_jmBo
 0eiapiU58kueicfNt6fJkZOfKYbduM0_iraoED9njamm_oX8YyqvICmiwFHs
 MP16PzcDkKWbqNY8pXz70vZZW0MkmVX7J4fNLAfLowEro.9N6pYLBp7AUweB
 _yuwGlaMnB.F_aqfX.2k3T8HB
X-Mailer: YahooMailClassic/11.1.3 YahooMailWebService/0.8.103.269680
Date: Fri, 11 Jun 2010 19:43:57 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] suspend blockers & Android integration
To: James Bottomley <James.Bottomley@suse.de>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       tytso@mit.edu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
In-Reply-To: <1276266502.2862.74.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 6/11/10, James Bottomley <James.Bottomley@suse.de> wrote:

> > Do we at least have a clean way that a driver can
> > reject a system suspend?  I've lost track of
> many
> > issues, but maybe this could be phrased as a QOS
> > constraint:  the current config of driver X
> needs
> > clock Y active to enter the  target system
> suspend
> > state, driver's suspend() method reports as
> much.  Then the entry to
> > that system state gets blocked
> > if the clock isn't enabled.
> 
> So in QoS modifications to android patches, the answer is "yes" ...
> except that the current android patch set didn't actually
> have this type
> of wakelock in it.

Except, we're not talking "wakelock" ... :)

So ... no, these cases still have no solution.
(I think  that's at least five years now.)


> The one thing that does look difficult is that these power
> constraints
> are device (and sometimes SoC) specific.

Exactly why they make good examples  for
turning up framework limitations... like
having overlooked constraints coming from
various SoC peripherals.

> Expressing them in a generic way
> for the cpu govenors to make sense of might be hard.

Requiring "CPU governors" to be involved in such
stuff feels a bit off-course to me.  At least, if
the involvement is very deep. The constraints are
from the integrated peripherals, not (usually)
from the CPU

There are plent of places to hang SoC or
device specific data, once there's awareness
that without such data, (which PCs hide behind
ACPI bytecode) the PM framework is missing out
on support for some desirable low power modes.


> 
> > (That QOS constraint should be removed when that
> > driver no longer needs to issue wakeups; that's
> > not quite the same as "removed by driver.resume().
> 
> The USB one needs user input, doesn't it,

I don't quite see that.  The drivers get called
in enough places, and they'll know if the system
is going to be in a suspend state where they need
to be partially 
aactive (with various QOS constraints, or they
can't work.

> since user hotplug might (or
> might not) be one of the wakeup sources.

If it wakes via hotplug, then the driver must
already Do The Right Thing; what input would
be needed  (Beyond changing the cable config)?

> 
> James
> 
> 
> --

