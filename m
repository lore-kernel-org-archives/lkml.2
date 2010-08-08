Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab0HHQRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 12:17:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54937 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0HHQRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 12:17:52 -0400
Date: Sun, 8 Aug 2010 17:17:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, pavel@ucw.cz, florian@mickler.org,
        stern@rowland.harvard.edu, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, menage@google.com, david-b@pacbell.net,
        James.Bottomley@suse.de, arjan@infradead.org, swmike@swm.pp.se,
        galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100808161709.GB7968@srcf.ucam.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm> <20100807061558.GA28087@thunk.org> <201008071111.05585.rjw@sisk.pl> <7F55B423-3F07-4DF7-B958-7380FDD53545@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7F55B423-3F07-4DF7-B958-7380FDD53545@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 10:46:59AM -0400, Theodore Tso wrote:

> True, but again, consider the MacBook.  If you plug in an iPod, the 
> machine will wake up for *just* long enough to let the iTunes sync the 
> iPod, but once its done, the machine goes back to sleep again 
> immediately.  I doubt MacOS has something called a "suspend blocker" 
> which prevents the machine from sleeping until iTunes finished, which 
> when released, allows the machine to suspend again immediately.  But 
> neither did I see any evidence that it took 30 seconds for some kludgy 
> polling process to decide that iTunes was done, and to allow the 
> MacBook to go back to sleep.  Clearly, the MacBook allows some 
> interrupts through, and some USB insert events through, but clearly 
> not all.  (Inserting a USB drive doesn't wake up the laptop; at least, 
> not for long.)

On the contrary, I suspect that it's precisely equivalent to userspace 
suspend blockers. There's no way to conditionalise USB wakeups - the 
system comes up when you plug or unplug any USB device. The system is 
then fully awake and I'd *guess* that ipods are magically exempted in 
some way, with itunes sending a signal when it's complete in order to 
allow the suspend policy daemon to trigger a suspend again.

> Can we do something as smooth with a Linux desktop?  And if not, why 
> not?  (Oh yeah, and wasn't this supposed to be the year of the Linux 
> Desktop?  :-)

gnome-power-manager supports applications inhibiting suspend, but right 
now I suspect that it'll never deal with the case where you resume with 
the lid closed. It's a simple matter of coding, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
