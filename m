Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1EDMoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:44:16 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:55900 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214Ab1EDMoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:44:15 -0400
X-Greylist: delayed 1952 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 08:44:15 EDT
X-Spam-Processed: srv201.gdsys.de, Wed, 04 May 2011 14:11:38 +0200
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Date: Wed, 4 May 2011 14:11:34 +0200
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-index: AcwKVGja0CMEr430SpuA2D/zu4XQtQ==
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: <linux-kernel@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110504121141Z
Subject: msleep() an load average
Thread-Topic: msleep() an load average
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.226; VDF: 7.11.7.146; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


LDD Chapter 7 says "In general, if you can tolerate longer delays than
requested, you should use schedule_timeout, msleep or ssleep.".

Following this rule, my kernel thread does:
while(1) msleep(1000);

Seconds later userspace guys start whining: "Your driver is evil,
loadavg is 1 and we did not even start our fancy application".

I say: "No, my code is perfectly fine, I followed LDD to the letter."

So the userspace guys head back to their cave, only to return after 5
hours of googling: "Hey, we know what you are doing. Your kernel thread
does uninterruptible sleeps. Wikipedia says, this means you are probably
waiting for disk activity."

Since I don't like having those whining userspace guys around I change
my code, reluctantly:
while(1) msleep_interruptible(1000);

Seconds later they say: "All hail great kernel hacker! You fixed it in
no time."

I appreciate their admiration, but still there are doubts in my mind: Is
this code really any better? Is the loadavg metric broken beyond repair?
Should I really avoid msleep, just to stop those userspace guys from
whining?
The truth must be out there ...

Cheers
Dirk


