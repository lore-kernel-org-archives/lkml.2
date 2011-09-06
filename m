Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1IFWmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:42:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:28820 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab1IFWmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:42:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,341,1312182000"; 
   d="scan'208";a="46151963"
Date: Tue, 6 Sep 2011 15:42:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clockevents: Use an atomic RCU notifier for
 clockevents
Message-ID: <20110906224228.GA5534@alboin.fm.intel.com>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.02.1109062120420.2723@ionos>
 <20110906203338.GL7761@one.firstfloor.org>
 <alpine.LFD.2.02.1109062235530.2723@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1109062235530.2723@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The idle code, at least the one in drivers/idle/intel_idle.c, does
> _NOT_ call into that code at all when a reliable lapic timer is
> available:

But the ACPI idle doesn't check that, so it still has a scalability problem.

Hmm ok so could add that check into acpi idle too I guess, but then ACPI
idle doesn't normally know anything about CPUs.

> Either you are using different code or your machine does not have that
> ARAT flag set.

The second test was using ACPI idle.

-Andi
