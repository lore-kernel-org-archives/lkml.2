Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1FNN5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 09:57:17 -0400
Received: from support.opsdc.com ([65.254.219.9]:40859 "EHLO support.opsdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FNN5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 09:57:16 -0400
X-Greylist: delayed 1555 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 09:57:16 EDT
Subject: Panic on OOM
From: Chris Fowler <cfowler@outpostsentinel.com>
Reply-To: cfowler@opsdc.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 09:31:16 -0400
Message-ID: <1308058276.2074.295.camel@compaq-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running into a problem in 2.6.38 where the kernel is not doing what
I'm expecting it to do.  I'm guessing that some things have changed and
that is what it going on.

First,  The tune at boot:

        f.open("/proc/sys/vm/panic_on_oom", std::ios::out);
        f << "1";
        f.close();

        f.open("/proc/sys/kernel/panic", std::ios::out);
        f << "10";
        f.close();

I want the kernel to panic on out of memory.  I then want it to wait 10s
before doing a reboot.

This program will consume all memory and make the box unresponsive

#!/usr/bin/perl

my @mem = ()
while(1) {
  push @mem, "########################";
}

It does not take long to fill up 1G of space.  There is NO swap on this
device and never will be.  I did notice that after a long period of time
(I've not timed it) I finally do see a panic and I do see "rebooting in
10 seconds..." .  It does not reboot.


I'm guessing that there are some tweaks or new behavior I just need to
be aware of.

Thanks,
Chris


