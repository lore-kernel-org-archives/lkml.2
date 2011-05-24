Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1EXSfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:35:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab1EXSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20110523193035.GA9170@elte.hu> <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
 <20110524060321.GA20904@elte.hu> <20110524061525.GA29815@elte.hu> <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 May 2011 11:34:14 -0700
Message-ID: <BANLkTi=bh+P07UPzhv9v=0x78o9+PUrCnw@mail.gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 10:45 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> Patch appended(I am sorry, should have caught this earlier. Looks like
> my system does keep the ioapic state intact during suspend/resume.)

Looks likely. My bisect just finished as I got this email, with

57a6f74023c7fd943160d7635bbc8d9f66e2ab54 is the first bad commit
commit 57a6f74023c7fd943160d7635bbc8d9f66e2ab54
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Wed May 18 16:31:36 2011 -0700

    x86, ioapic: Consolidate ioapic_saved_data[] into 'struct ioapic'

    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: daniel.blueman@gmail.com
    Link: http://lkml.kernel.org/r/20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 0ae77b7536a88d0ce4f789a7c870aa3103ccc1d5
3460a9ec2b6a017d91b8fa6465e8d7d7cd8be71d M	arch

and I'm now going back to top-of-git and applying your patch to verify
that it fixes it. But it looks rather likely that it does.

                     Linus
