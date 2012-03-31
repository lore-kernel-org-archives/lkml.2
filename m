Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab2CaUpI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:45:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45285 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2CaUpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:45:06 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 31 Mar 2012 22:44:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: On patch "Remove all #inclusions of asm/system.h"
Message-ID: <20120331224452.1862a2b4@stein>
In-Reply-To: <31597.1333222293@redhat.com>
References: <20120329153409.7295eda9@stein>
	<31597.1333222293@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 31 David Howells wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > For example, drivers/firewire/{core-device,core-topology,ohci,sbp2}.c use
> > smp_rmb()¹ and used to include asm/system.h.  Now they do not include
> > asm/barrier.h.  Is this by mistake or on purpose?
> 
> I tried to make sure allyesconfig worked for x86_64 and a bunch of defconfigs
> worked.  I can't guarantee that that got 100% coverage.  I also knew there
> would be some breakage from the base Linux kernel having moved on by the time
> Linus pulled myu patches - though I don't know if this is the case here (I
> suspect not).

It's not a problem; they now get barrier.h via spinlock.h.  I just
wondered whether absence of #include <asm/barrier.h> in those files had a
deeper non-obvious meaning.  Since it doesn't I will just put that include
in them next time around when I do some housekeeping there.
-- 
Stefan Richter
-=====-===-- --== =====
http://arcgraph.de/sr/
