Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2EOR4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:56:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62444 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2EOR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:56:12 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
To: Arnd Bergmann <arnd@arndb.de>, Magnus Damm <magnus.damm@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, horms@verge.net.au,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <201205150832.10069.arnd@arndb.de>
References: <20120514105424.8596.38355.sendpatchset@w520> <201205142107.51335.arnd@arndb.de> <CANqRtoSts80a-Pgas23Um8FFtnSeeu2oZKNehdfymLWoTOSspA@mail.gmail.com> <201205150832.10069.arnd@arndb.de>
Date: Tue, 15 May 2012 11:56:08 -0600
Message-Id: <20120515175609.04A4D3E080A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 08:32:09 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 14 May 2012, Magnus Damm wrote:
> > Right, I agree. Relying on a fixed DTB in an unreliable boot loader is
> > the last thing I want to do.
> > 
> > So if your boot loader can't pass DTB to the kernel, and you want to
> > have a single kernel supporting multiple boards, then do you see
> > anything wrong with based on mach-type do a run time decision (in
> > arch/arm/boot/compressed/) to override the ATAG from the boot loader
> > with a compiled-in per-board DTB?
> 
> I know that we have discussed this in the past, but I don't remember
> the outcome of the discussion, maybe someone else can help out here
> (Grant?)
> 
> It's definitely technically possible to do it, but it could either be
> that nobody has bothered to do the implementation, or that we had good
> reasons against it and decided not to allow this.

Tony and I talked about this quite a bit during the last Connect.  The
plan is to extend the existing bootwrapper ATAGs to DT code to allow
appending multiple .dtbs to the zImage and selecting the correct one
based on the machine number.  It shouldn't be very complicated, but I
haven't had time to implement it.

g.

