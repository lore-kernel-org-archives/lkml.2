Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0FKRIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 13:08:06 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:43992 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757919Ab0FKRHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 13:07:55 -0400
Date: Fri, 11 Jun 2010 13:07:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Linux 2.6.34 causes system lockup on Compaq Presario 2200 Laptop
In-reply-to: <AANLkTilrLYu6H3GtAcP-cHpFvrm3v22uCw2EUeW_ZK0k@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1006111258430.6282@localhost.localdomain>
References: <AANLkTil6GGSoc8TpzRacr1LZBZS3ee3H1ejYDSqfdul4@mail.gmail.com>
 <20100529202253.0bd18bbd.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1006091821060.1402@localhost.localdomain>
 <AANLkTilrLYu6H3GtAcP-cHpFvrm3v22uCw2EUeW_ZK0k@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010, Jeffrey Merkey wrote:

> Len,
> 
> I am having trouble getting a trace of this because its down hard to
> reproduce.  The reason is the lockup happens before I log into the
> laptop.  i.e. I boot 2.6.34 and if I let the laptop just sit there is
> happens.  If I log in and start doing work on it, it does not seem to
> happen.  It's related to using the laptop on battery mode with the
> charger removed.  I have a 2U appliance setup I am working on today
> and this frees up the laptop to try to reproduce this.  The flaky
> battery power misreporting was in fact accurate.  The battery in that
> laptop is 6 years old and does have low power.  I am certain the
> lockup if related though.  I will try to reproduce today and setup the
> trace to run after boot.  I have had it sitting there for an  hour and
> it has not reoccurred.  Let me try through today and if I cannot
> reproduce, close the bug.

Good to know, Jeff.

One possibility is that the old battery is confusing
the embedded controller -- possibly exposing a firmware bug.
The EC, in turn, is fully capable of hanging the OS.

If you *can* reproduce it, it may be interesting to bisect
recent changes to drivers/acpi/ec.c

Also, if you can reproduce it, it would be good to verify
that the problem occurs only when the battery driver is loaded.

thanks,
-Len

> > Please attach the output of acpidump here:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=16136

We could still use this output -- note that you can
capture it at any time, independent of the failure,
and independent of the kernel -- as it is simply
a copy of the tables that the BIOS is exporting to Linux.

thanks,
-Len Brown, Intel Open Source Technology Center
