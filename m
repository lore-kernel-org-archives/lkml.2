Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2DQTKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:10:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58760 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab2DQTKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:10:48 -0400
Date: Tue, 17 Apr 2012 20:10:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20120417191042.GB3932@decadent.org.uk>
References: <20120417141856.GA19507@zod.bos.redhat.com>
 <20120417185007.GA3742@mcarlson.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120417185007.GA3742@mcarlson.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: tg3 'No PHY devices' loading issue
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 11:50:07AM -0700, Matt Carlson wrote:
> On Tue, Apr 17, 2012 at 10:18:57AM -0400, Josh Boyer wrote:
> > Hi Matt and Michael,
> > 
> > I'm seeing an odd issue with the tg3 driver on one of my development
> > machines.  I've tried kernels 3.2.10, 3.3.0, 3.3.1, 3.3.2 and 3.4-rc3
> > and they all seem to exhibit this issue now.  When the machine boots
> > and the tg3 driver is loaded, it fails to find a PHY and then reports
> > 'Problem fetching invariants of chip'.  If I do a rmmod/modprobe of
> > tg3 after login, the probe seems to work fine and ethernet works as
> > expected.  You can see this in the dmesg below:
[...]
> The 57788 uses the broadcom phylib module.  For some reason, it isn't
> available the first module load attempt.  A while ago, code was added to
> phylib to request modules from userspace if the particular phy support
> code wasn't already loaded.  It looks like this mechanism isn't working
> too well the first time through.
[...]

At a guess, tg3 is in the initramfs but broadcom isn't.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
