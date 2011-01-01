Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1AAAvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 19:51:13 -0500
Received: from science.horizon.com ([71.41.210.146]:52037 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751206Ab1AAAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 19:51:12 -0500
Date: 31 Dec 2010 19:51:09 -0500
Message-ID: <20110101005109.11018.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Where are the semantics of MSC_SCAN & MSC_RAW input events defined?
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to rework the ati-remote.c driver to use the input layer
better, such as supporting keyboard remapping.

And I'm finding documentation on the input layer... lacking.  What's the
point of these two event types?  Should I emit either or both when someone
presses a button?  Does it matter if the button has an EV_KEY mapping?

If I should generate multiple input events for one keypress, what order
should they be in?

I notice that atkbd.c generates MSC_SCAN, then EV_KEY.
But Documentation/laptops/thinkpad-acpi.txt says
"A Hot key is mapped to a single input layer EV_KEY event, possibly
followed by an EV_MSC MSC_SCAN event."

I notice there was a proposed patch to fix this in 2007:
http://www.mail-archive.com/linux-input@atrey.karlin.mff.cuni.cz/msg00482.html

This recommends generating EV_KEY/KEY_UNKNOWN events for unfamiliar keys,
which atkbd.c (probably the most-used input handler) does not do.


The other question is that the ATI remote retransmits scan codes while
they key is held down, and key-up has to be inferred via a timeout.
Should I generate an MSC_SCAN event for each true reception, or only
for the synthesized key events?


I have a few other questions about the input layer:
- Should I fill in the input_id with the BUS_USB and the
  device's idVendor, idProduct, and bcdDevice?
- What should I put in the input->phys and input->uniq fields?

Thank you!
