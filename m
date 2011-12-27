Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1L0GfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:35:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41336 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1L0GfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:35:03 -0500
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fix passive zone thermal throttling
Date: Mon, 26 Dec 2011 22:34:43 -0800
Message-Id: <1324967687-10559-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a laptop with a broken fan and it would constantly shut down
under load. In principle passive thermal zone throttling was supposed
to prevent that by slowing down the CPU, but this didn't work.

This patchkit makes it work on my system.

It turned out to be a combination of problems: the EC driver 
talking to the embedded controller on my system would frequently
get out of step, which resulted in missing temperature events.
While not completely cured it's much better now with some
replies.

The other more serious problem was that the throttling code
never really worked on multi-core systems: it only lowers
the frequency of a single CPU, that gets the event, but the
other threads/cores still keep the frequency up. Also worse
throttling would never be invoked before the lowest frequency
is reached.

The first patch is merely a cleanup, the other patches fix
these problems.

Now that the kernel is fixed I can send the laptop in for repair.

-Andi

