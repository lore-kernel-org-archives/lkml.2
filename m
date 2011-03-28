Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab1C1NLG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:11:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1C1NLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:11:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Mon, 28 Mar 2011 15:11:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103261225.03504.arnd@arndb.de> <20110326151050.GA27822@suse.de>
In-Reply-To: <20110326151050.GA27822@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103281511.00621.arnd@arndb.de>
X-Provags-ID: V02:K0:SdeTq25D8CtuOjXHAbMP39/aN83OWCafpRx3UNeou3P
 rPLoRtxpBo6usWOKmq3BJuFRS8J2KYdBfRmgwDcbd3H36HotEz
 PpQPR0cqpAatoL+Ng6EQmQ5aSVU/Ez7UPctL1T80YBdEB6cTvf
 Sxd/Lhbfh4EsJ6CBMxxRHi9fI4nF2FksEalWqE0LNA1BtHRnVU
 swRiDYg8PcKGAZZ7DyUvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 March 2011, Greg KH wrote:
> On Sat, Mar 26, 2011 at 12:25:03PM +0100, Arnd Bergmann wrote:
> > On Saturday 26 March 2011 00:28:47 Greg KH wrote:
> > 
> > > Yes, that is how it used to be, but then it turns out that both of them
> > > are really just "subsystems" as far as it all goes.  They are just ways
> > > that devices are bound to drivers in a logical manner.  We have patches
> > > floating around that get rid of both busses and classes to merge them
> > > together, which is the end goal here.  I know Kay has posted detailed
> > > reasons for why this all is on lkml in the past, and had working code
> > > about 5 years ago, it's just been slow going...
> > 
> > How will that work? I suppose we can't really change the directory
> > structure anyway, so to users it will still look like it does today,
> > even if the kernel just uses the same code for bus and class internally.
> 
> Yes.  But we can have symlinks instead of "real" /sys/class and
> /sys/bus directories like we do for /sys/block today.  All of the major
> tools that use sysfs work properly with a /sys/subsystem/ setup today
> thanks to Kay's efforts.

I see. The migration from /sys/bus to /sys/subsystem plus symlinks
makes sense, but I still think that having symlinks that make sense
would be better than having symlinks that are purely there for historical
reasons.

One major flaw I see with registering abstract subsystems as a bus is
that a bus connected to the concept of a device_driver, and there is
a list of drivers with their respective devices in /sys/bus/*/drivers,
which would always be empty in this case. Similarly, the
/sys/bus/*/devices/*/driver symlinks for these subsystems would point
to drivers on other buses, unlike the respective symlinks for real
buses.

	Arnd
