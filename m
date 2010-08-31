Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0HaMqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:46:49 -0400
Received: from ppsw-30.csi.cam.ac.uk ([131.111.8.130]:45806 "EHLO
	ppsw-30.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab0HaMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:46:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C7CFAD1.6030707@jic23.retrosnub.co.uk>
Date: Tue, 31 Aug 2010 13:51:29 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100830 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Balbi <me@felipebalbi.com>, Hemanth V <hemanthv@ti.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "igor.stoppa@nokia.com" <igor.stoppa@nokia.com>,
        "kai.svahn@nokia.com" <kai.svahn@nokia.com>
Subject: Re: Sensors and the input layer (was Re: [RFC] [PATCH V2 1/2] input:
 CMA3000 Accelerometer driver)
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>	<20100829184904.GC26209@core.coreip.homeip.net>	<36abcb34cfbf34724d9a581a75b53e76@secure211.sgcpanel.com>	<20100830214025.2f9677a1@lxorguk.ukuu.org.uk>	<20100830204412.GA28711@core.coreip.homeip.net>	<AANLkTims1CagvPZQjTmYrOVi8REeLVbyyt3kEY_tsCtx@mail.gmail.com>	<20100830214355.GB28865@core.coreip.homeip.net> <20100831104659.11ebc8a0@lxorguk.ukuu.org.uk>
In-Reply-To: <20100831104659.11ebc8a0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/10 10:46, Alan Cox wrote:
>> IIO which is currently in staging.
> 
> Except we had ALS before that as a layer and Linus vetoed it. So there is
> zero faith in IIO ever going anywhere.
I have more faith - those developing it have limited time, but we will get
there. (another plug for anyone interested to get involved!)

IIRC Linus and others disliked ALS for two reasons...
* It was too specific.  They didn't want to fragment sensors types that much.
* Userspace is used to dealing input and in some cases a light sensor can look
  like a switch.
The first certainly doesn't apply to IIO, the second will be fixed via an
input bridge.

If Linus isn't happy we'll just have to work on convincing him.
> 
> Instead we now have about ten different light sensor APIs to the point
> developers are writing a toolkit userspace plugin for *each* sensor.
I agree. This is a big problem.  We have in the past talked about
allowing interfaces to be standardized even if the underlying subsystem
is still open to debate.  
We did openly debate the interface for some time with ALS...

After we went over this with IIO we decided to match / extend hwmon where
ever possible. Obviously that only covers sysfs interfaces, but it is a start.
We also openly debate all new elements (and in theory at least keep
the admittedly huge abi document up to date).  A large set of doc updates and
code fixes relating to the interface from Manuel Stahl went to Greg KH
this morning as result of his work on general userspace tools.

On the chrdev side of things life is much more complex as performance
and overheads become an issue.

Jonathan

p.s. Matthias Nyman's email address is bouncing so I've removed it from the cc list.


