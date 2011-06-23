Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab1FWPLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:11:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59158 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754653Ab1FWPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:11:47 -0400
Date: Thu, 23 Jun 2011 11:11:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kevin Hilman <khilman@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support
 for generic domains (v3)
In-Reply-To: <201106231644.50965.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1106231106250.2033-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011, Rafael J. Wysocki wrote:

> > It might be worthwhile to include a little warning about the difference 
> > between suspend and hibernate.
> 
> Well, there already is one:
> 
> "* The driver's idea of the device state may not agree with the device's
>     physical state.  This can happen during resume from hibernation."
> 
> (in Documentation/power/runtime_pm.txt).  Also, the new text in the patch
> https://lkml.org/lkml/2011/6/23/200 I've just sent says literally:
> 
> "If that is the case and none of the situations listed above takes place, it
>  may be more efficient to leave the devices that had been suspended before
>  the system sleep began in the suspended state."
> 
> where the "situations listed above" include it.
> 
> Do you think that's not sufficient?

The preceding text in your new patch says:

+On some systems, however, system sleep is not entered through a global firmware
+or hardware operation.  Instead, all hardware components are put into low-power
+states directly by the kernel in a coordinated way.  Then, the system sleep
+state effectively follows from the states the hardware components end up in
+and the system is woken up from that state by a hardware interrupt or a similar
+mechanism entirely under the kernel's control.  As a result, the kernel never
+gives control away and the states of all devices during resume are precisely
+known to it.

It should say "system suspend" rather than "system sleep".

Then to drive the point home, the following sentence chould say 
something like this:

If that is the case and none of the situations listed above takes place
(in particular, if the system is waking up from suspend and not from
hibernation), it may be more efficient to leave the devices that had
been suspended before the system suspend began in the suspended state.

Alan Stern

