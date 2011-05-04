Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab1EDOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:47:49 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:39827 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab1EDOrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:47:49 -0400
X-Spam-Processed: srv201.gdsys.de, Wed, 04 May 2011 16:47:45 +0200
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Date: Wed, 4 May 2011 16:47:44 +0200
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BEA0@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-index: AcwKZ5uqRJNP0dhdQACvsacv7LxJVQAAZRig
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de> <4DC1568B.2080004@gmail.com> <48D3D52125C49B43AE880038E2E5314BB5BE9E@SRV101.gdsys.de> <4DC16322.2090607@ladisch.de>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Clemens Ladisch" <clemens@ladisch.de>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110504144748Z
Subject: RE: msleep() an load average
Thread-Topic: RE: msleep() an load average
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.226; VDF: 7.11.7.148; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > Uninterruptible sleeps count as I/O load.
> > 
> > Is there any practical reason behind this or was it just an 
> igenious 
> > invention to annoy those smug userspace developers?
> 
> Historically, uninterruptible sleeps were the best way to 
> detect I/O load.  Furthermore, a process that is doing I/O is 
> very likely to continue running soon, while other sleeps are 
> more likely to indicate that the process is waiting for some 
> event to wake it up to begin doing something, so this better 
> predicts CPU load.  Finally, a busy device is likely to 
> prevent other programs from running well, so it makes sense 
> to count this against the load.
> 
> msleep() is commonly used to handle device communication 
> delays, which is essentially the same case as waiting for 
> disk I/O.  It might be possible to introduce some new flags 
> or functions to allow long uninterruptible sleeps that do not 
> affect the load, but this has not been necessary so far 
> because knowledge of this quirk of the load heuristic is 
> necessary for every great kernel hacker.  ;-)

So summarizing we could say that semantics for signalling I/O load to
loadavg are historically crippled and msleep() should be avoided if you
don't want to mess up loadavg.
In addition I realize that studying LDD does not make you a great kernel
hacker ;)

Cheers
Dirk


