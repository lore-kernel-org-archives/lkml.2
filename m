Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1IFTYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:24:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:51769 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab1IFTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:23:56 -0400
Date: Tue, 6 Sep 2011 21:23:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] clockevents: Use an atomic RCU notifier for
 clockevents
In-Reply-To: <1314652136-11350-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109062120420.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Use an atomic_notifier instead of a raw_notifier for the clockevents
> notification.
> 
> This avoids a global lock in the idle path, is a scalability
> problem. With this patch we don't have a global lock anymore
> at least on systems with an always running timer.

And why is that code called on a system with an always running local
apic timer at all? The broadcast horror is explicitely only for those
systems with wreckaged hardware.
 
Either the patch makes no sense or the changelog or both.

Thanks,

	tglx
