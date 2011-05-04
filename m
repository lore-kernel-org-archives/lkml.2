Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1EDOEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:04:15 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:53520 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1EDOEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:04:13 -0400
X-Spam-Processed: srv201.gdsys.de, Wed, 04 May 2011 16:04:11 +0200
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Subject: RE: msleep() an load average
Date: Wed, 4 May 2011 16:04:06 +0200
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE9F@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: msleep() an load average
thread-index: AcwKYYD2Yj9FuKdGRwKsSTSve6wMZgAAkxbQ
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de> <4DC158E5.50908@ladisch.de>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Clemens Ladisch" <clemens@ladisch.de>
Cc: <linux-kernel@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110504140413Z
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.226; VDF: 7.11.7.148; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > while(1) msleep_interruptible(1000);
> > 
> > Is this code really any better?
> 
> You should handle signals, probably by blocking any that 
> you're not interested in, and exiting on any fatal one.

As I am a great kernel hacker, all signals are blocked ;)

> Anyway, polling is bad; this code forces the CPU to wake up 
> once per second.  What is your thread _actually_ waiting for?
> (I guess it has more code than what you wrote?)

Sure, polling is bad, but sometimes hard to avoid. My system is
monitoring some hardware it doesn't trust and looks once in a while if
it's still alive, just to make sure. As this is an embedded system
without any energy saving measures, waking up the CPU is not that much
of a problem.

Cheers
Dirk
--------------------------------------------------------------------------
Guntermann & Drunck GmbH Systementwicklung 
Dortmunder Str. 4a 
D-57234 Wilnsdorf - Germany 
Tel: +49 (0) 27 39 / 89 01 - 100  Fax: +49 (0) 27 39 / 89 01 - 120 
E-Mail: mailto:sales@gdsys.de Web: www.gdsys.de
--------------------------------------------------------------------------
Geschaeftsfuehrer: 
Udo Guntermann - Martin Drunck - Reiner Ruelmann - Klaus Tocke
HRB 2884, Amtsgericht Siegen - WEEE-Reg.-Nr. DE30763240
USt.-Id.-Nr. DE 126575222 - Steuer-Nr. 342 / 5835 / 1041
--------------------------------------------------------------------------
DQS-zertifiziert nach ISO 9001:2008
--------------------------------------------------------------------------


