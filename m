Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0JAVL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 17:11:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42503 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab0JAVL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 17:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <1285965973.2463.129.camel@pasglop>
References: <20100930221351.682772535@linutronix.de> <20100930221743.014571381@linutronix.de>
 <1285893737.2463.4.camel@pasglop> <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
 <1285965973.2463.129.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 2 Oct 2010 06:11:33 +0900
X-Google-Sender-Auth: _gZpSanF8yi0Jy91B0wyZ4cZyFM
Message-ID: <AANLkTi=C+tti-08iti=o-fJG2rj7W5EGvB75u6njz2w9@mail.gmail.com>
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 2, 2010 at 5:46 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2010-10-01 at 15:07 +0200, Thomas Gleixner wrote:
>> On Fri, 1 Oct 2010, Benjamin Herrenschmidt wrote:
>>
>> > On Thu, 2010-09-30 at 23:18 +0000, Thomas Gleixner wrote:
>> > > plain text document attachment (powerpc-use-new-allocator.patch)
>> > > Use the new functions and free the descriptor when the virq is
>> > > destroyed.
>> >
>> > Looks ok as a first pass, but we should go further and replace the
>> > allocator we have in powerpc to use yours instead.
>> >
>> > Then I should get rid of my big irq_map that maps virq to HW number &
>> > domain pointers and instead put those in the irq data. Any objection to
>> > me sticking some archdata there for that purpose ?
>>
>> No, though if we can avoid another void pointer and have a sensible
>> data structure for it would be nice.
>
> Yes, I'm thinking about an arch defined structure like I did for struct
> device.

Before doing that, I'd like to see what data members are still needed.
 The powerpc use-case is quite sane, and it may turn out to be common
code after all.  I certainly want to port the PowerPC functionality to
ARM.

g.
