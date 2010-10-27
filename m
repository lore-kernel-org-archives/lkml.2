Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0J0RXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:23:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32987 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0J0RXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:23:45 -0400
Date: Wed, 27 Oct 2010 19:23:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "Luck, Tony" <tony.luck@intel.com>,
        BorislavPetkov <petkovbb@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v3 0/8] ACPI, APEI patches for 2.6.37
Message-ID: <20101027172343.GB22171@basil.fritz.box>
References: <1288157312-10441-1-git-send-email-ying.huang@intel.com>
 <1288174050.15336.1507.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288174050.15336.1507.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

> All you've done is decreased the arch/x86/ footprint of the patch
> series, but neither you nor Andi have addressed the technical arguments
> against adding this ABI.

What were the technical arguments? I don't remember any.

I remember just reading some rants from people who clearly
never even looked at this code and made no attempt to review
it. It was very untechnical.

> Nor have you engaged in conversation with the other EDAC people on how

There was a long thread on it last time, patchkit really is based
on at least some of the sane feedback from that.

But in a nutshell:

This code is quite orthogonal to EDAC: EDAC does enumeration
(or some weird variant of it at least), exporting of counter registers
and some dumping of the registers into the kernel log. 

APEI doesn't do enumeration or counting or registers, it's really just
an interface to retrieve some events from firmware, stop the machine on 
fatal events and pass them on and support managing of the events in a 
backing store.

It's also a standardized interface supported by multiple vendors,
it's not proprietary at all as some people claimed.

> to extend the existing interface, or even work towards creating
> something new that would cater to all interested parties.

Open to serious input. Do you have anything concrete?
Please be concrete and technical ideally with references to code.

Some common comments I heard:

If you want enumeration it could be probably done in some 
EDAC2 variant which fixes the worst problems in the current EDAC interface.
But it won't be talking to APEI directly anyways -- APEI
doesn't do enumeration -- it's really a different problem
and won't be solve by this code.

If you want to move the event channel to perf: we looked at that
and it's not practical with the current infrastructure. And
not a very good fit anyways because the requirements
as quite different from the ones perf was designed for.
For more details see the big thread on the previous posting.

If you want to move the backing store to a file system
or MTD: we actually looked at that too but there were too
many problems and it's really far too much code for the simple 
use case.

Short term this code just attempts to handle fatal chipset errors
(which are a long standing problem in Linux) in a sane way.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
