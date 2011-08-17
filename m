Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1HQS5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 14:57:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37463 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab1HQS5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 14:57:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Aug 2011 20:57:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
Message-ID: <20110817205738.57aa5dd9@stein>
In-Reply-To: <4E4BD560.4010806@bootc.net>
References: <4E4BD560.4010806@bootc.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 17 Chris Boot wrote:
> Now that we have a nice SCSI target framework in the kernel, and drivers 
> either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I 
> was wondering about the possibility of adding FireWire to that list. 
> Apple Macs have had a FireWire Target Disk mode for a long time, and 

Side note:  This target mode is a feature of their OpenFirmware and EFI
firmwares, not of the Mac OS and the OS X.  Though both firmware- and
operating-system-implemented SBP-2 targets certainly have their use cases.
Aside from the SBP-2 target in Macs and from Oracle Endpoint, I only know
of SBP-2 targets that are built upon dedicated bus bridge silicon.

> there is even a program called Endpoint[1] that apparently does this on 
> Linux though it looks completely untouched since 2003 and no longer 
> works as it depends on the old FireWire stack.

It can be made to work again if it and libraw1394 are slightly extended to
use a different API for Configuration ROM changes.  Or Endpoint could be
ported from libraw1394 to <linux/firewire-cdev.h>.  But then it would of
course not benefit from the generic SCSI target infrastructure, e.g. WRT
administration, backing storage choices, or command set support.

> I would very much like to see something like this added to the kernel, 
> and would very much like to contribute to writing this feature. However 
> my kernel development knowledge is very limited indeed so this would 
> require a lot hand-holding and mentoring.
> 
> What's the interest in such a feature?

People keep asking for it; very infrequently though.

> Would anyone be able to give some (a lot?) of their time to help write
> this?
> 
> Thanks,
> Chris
> 
> [1] http://oss.oracle.com/projects/endpoint/

I for one can answer questions about firewire-core's driver API but do not
have much spare time for more, for the time being.

BTW, a kernelspace SBP-2 target drivers would use several of the FireWire
features that the firewire-net driver uses too.  So the sources of that
driver may be of help where the firewire-core kerneldoc comments are
missing or are not providing the bigger picture.
-- 
Stefan Richter
-=====-==-== =--- =---=
http://arcgraph.de/sr/
