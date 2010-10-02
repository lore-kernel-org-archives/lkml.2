Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab0JBQwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:52:23 -0400
Received: from thunk.org ([69.25.196.29]:59359 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0JBQwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:52:22 -0400
Date: Sat, 2 Oct 2010 12:52:15 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Christian Casteyde <casteyde.christian@free.fr>
Subject: Re: [Bug #17361] Watchdog detected hard LOCKUP in
 jbd2_journal_get_write_access
Message-ID: <20101002165215.GK21129@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Christian Casteyde <casteyde.christian@free.fr>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.IiE.Qp6nMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sQALkqF1FWE.A.IiE.Qp6nMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 26, 2010 at 10:04:13PM +0200, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17361
> Subject		: Watchdog detected hard LOCKUP in jbd2_journal_get_write_access
> Submitter	: Christian Casteyde <casteyde.christian@free.fr>
> Date		: 2010-08-29 19:59 (29 days old)

See my latest comment here:

    https://bugzilla.kernel.org/show_bug.cgi?id=17361#c14

This subject line is highly misleading, since after -rc4, the stack
traces are in places all over the kernel, in other places other than
ext4/jbd2.  So I fear no one is looking at this bug report given the
highly misleading subject line.

It looks like you have spinlock debugging, and yet there wan't any
spinlocks listed on the initial ext4 might_sleep() warning.  So
something looks highly confused.

The fact that you closed other bugs as duplicates of this one that
relate to kmemcheck makes me wonder if this is really a kmemcheck bug.
(If so, the subject line here is doubly, doubly misleading.)

Do you see any symptoms if you turn off kmemcheck?  Are you sure this
isn't just only a kmemcheck bug?

					- Ted
