Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab1CXNLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:11:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1CXNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:11:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Date: Thu, 24 Mar 2011 14:10:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com> <201103231720.27107.arnd@arndb.de> <F28B59AD52D84B479DCA469824475335065A9EF74E@hasmsx503.ger.corp.intel.com>
In-Reply-To: <F28B59AD52D84B479DCA469824475335065A9EF74E@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241410.53871.arnd@arndb.de>
X-Provags-ID: V02:K0:bwqdlNw/13FCFB1EPeYRO0z6VP3s67CuAjGFu9uohkJ
 pHOxmGKrab2Bk/IKymHhWXBfJk2cT4g2mlqzYrhf5d6it6l/UN
 5a6nl3KdyL5ewZTcQI1jzl/P0xh0nGs5PVyukK1qeDz9c2gL32
 x5XqkuBUe+jnL2vw+HOZ8NMQE17bbYRRmgSnYX7OxURkvZ+P7u
 ifjJ95FDWp1woR6bpqH9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 March 2011, Weil, Oren jer wrote:
> >For a simple example, look at drivers/watchdog/riowd.c (most other files in
> >that directory do as well), just replace the riowd_writereg() function in
> there
> >with one that calls an exported function from your hardware. This should
> >really be trivial to do.
> 
> our Watchdog is a FW Client (FW Feature) so in order to communicate with it
> we need 
> use the MEI Driver functions. (Send Connect Message, Send and Recv Data).
> AFAIK, I can't use sys_open/sys_write to communicate with the MEI Driver, I
> need to expose
> functions that handles all of that communication, right?

Yes. Use EXPORT_SYMBOL_GPL().

> >> So you need to add support to the watchdog infrastructure for this?
> >> For some reason I thought you could kick the watchdog from within
> >> kernel code, did I get this wrong?
> 
> >A watchdog must be triggered from user space, in Linux we do this by
> writing
> >to /dev/watchdog. If you did it from kernel space, the watchdog would not
> >detect the case where the system is half-broken and still able to trigger
> the
> >watchdog, but not do much beyond that.
> 
> The Intel AMT Watchdog is not like a regular Watchdog,  our interface is
> like regular watchdog (set timeout API, ping  API and etc..)
> But when the watchdog expired the system will not be reboot, the AMT
> Watchdog is sending a OOB Message/Event
> to remote management console and the console software can decide what to do.
> (it can notify the operator to check why
> the system hangs, it can send a OOB reboot command to reboot the hang system
> and etc...)

Close enough, I guess.

	Arnd
