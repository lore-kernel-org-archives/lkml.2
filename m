Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab0IGTdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:33:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:3234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab0IGTdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,329,1280732400"; 
   d="scan'208";a="552394503"
Subject: Re: [PATCH] [arch-x86] Allow SRAT integrity check to be skipped
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20100903063934.GA25863@elte.hu>
References: <20100901213318.19353.54619.stgit@localhost.localdomain>
	 <20100902065731.GB29972@elte.hu> <20100902100308.GA17167@basil.fritz.box>
	 <20100903063934.GA25863@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 12:38:57 -0700
Message-ID: <1283888337.18468.9.camel@pjaxe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 23:39 -0700, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > This isnt a particularly useful solution to users of said systems - 
> > > they have to figure out that this option exists, and then they have 
> > > to enter this option on the boot line.
> > 
> > This usually only happens in early preproduction systems. So far the 
> > BIOS always got fixed before they shipped to users.
> 
> 'Usually' != 'always'. Read the changelog:
> 
>   ' There are BIOSes in production that have these failures, so this will 
>     allow people in the field to work around these BIOS issues. '
> 
> Peter, which system in production that has this problem? That one needs 
> a DMI match.

It's one SKU of a Nehalem-EX system.  The BIOS for that SKU has an issue
with resolving SRAT hotplug enumeration, and screws up the table.  Other
SKU's of this same platform do not have the issue.  Efforts are underway
to get this BIOS fixed, but in the meantime, there's nothing for users
to work around the bug (aside from disabling memory hotplug in the
BIOS).  Another platform almost shipped with the same symptoms, but
caught it and had it fixed before it shipped (didn't catch it early
because Windows wasn't failing, and most of the testing on that platform
was done under Windows).

I agree with Andi that adding DMI strings would be overkill and would
leave clutter once the BIOS is fixed.  I look at this patch as a
stop-gap measure for people to fall back on until a newer BIOS is
available to correct the NUMA enumeration issues.  Without it, we have
nothing to point users to when they run into this, waiting for a new
BIOS.

Cheers,
-PJ

