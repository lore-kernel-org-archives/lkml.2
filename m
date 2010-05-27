Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab0E0K4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:56:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56200 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754992Ab0E0K4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:56:43 -0400
Date: Thu, 27 May 2010 12:04:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
Message-ID: <20100527120410.43a0e04c@lxorguk.ukuu.org.uk>
In-Reply-To: <4BFE1735.9080806@linux.intel.com>
References: <4BFDDBA9.4010702@np.css.fujitsu.com>
	<1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
	<4BFE1735.9080806@linux.intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In general deciding what to do on a MCE is rather complicated
> and probably too much for any die handler.

True enough

> But today we don't really need it. notify_die() is primarily for debuggers
> of all kinds, and I never liked the idea to call a debugger on a machine
> check.

That would be because you don't do driver work I suspect. If you are
doing driver work then its extremely useful ending up in the debugger
when you get an MCE because some random bit of hardware on the bus
decided to throw a tantrum.

This is particularly the case with AMD/ATI and AMD/Nvidia chipset systems
which tend to throw this kind of error if you prod some of the chipset
controllers (eg the Nvidia SATA) in them in just the wrong way.

So NAK simply removing it. As a driver writer I want to end up in the
debugger when this happens so I can work out what led up to the MCE.

Alan
