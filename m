Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0ELDLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 23:11:11 -0400
Received: from services04.student.cs.uwaterloo.ca ([129.97.152.11]:39166 "EHLO
	services04.student.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab0ELDLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 23:11:07 -0400
X-Greylist: delayed 2111 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2010 23:11:06 EDT
Date: Tue, 11 May 2010 22:35:49 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: T500 cdrom drive never stops spinning until mount.
Message-ID: <20100512023549.GA22623@cpu18.student.cs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (services04.student.cs.uwaterloo.ca [129.97.152.11]); Tue, 11 May 2010 22:35:52 -0400 (EDT)
X-Miltered: at minos with ID 4BEA1407.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 0142e59f-ac9a-444b-bc75-f507eaf54789
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ThinkPad T500 has a SATA cdrom drive attached to an Intel ICH9M/M-E
SATA ACHI controller.  Upon inserting a disk into this drive, if sr-mod
is loaded, the disk will never stop spinning by itself:  it will spin up
to full speed, then start slowing down, but just before it stops, it
will spin up to full speed, then start slowing down, ad infinitum.

If sr-mod is not loaded, the disk stops spinning right after insertion.
It is only possible to remove sr-mod when the disk is spinning at full
speed (all other times the module is in use), and then the disk stops.

Mounting the disk also causes it to stop spinning (and it remains
stopped after unmounting it).

I see this behaviour with both 2.6.32 and 2.6.34-rc7.
