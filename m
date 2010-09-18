Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0IRNnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 09:43:47 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:53546 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0IRNnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 09:43:46 -0400
To: Damien Wyart <damien.wyart@free.fr>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Artur Skawina <art.08.09@gmail.com>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
	<alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
	<20100918074939.GA3275@brouette>
From: Nix <nix@esperi.org.uk>
Emacs: Our Lady of Perpetual Garbage Collection
Date: Sat, 18 Sep 2010 14:43:06 +0100
In-Reply-To: <20100918074939.GA3275@brouette> (Damien Wyart's message of "Sat, 18 Sep 2010 09:49:39 +0200")
Message-ID: <87iq23i2vp.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-HP_X86_64_4CPU-Metrics: spindle 1245; Body=12 Fuz1=12 Fuz2=12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 Sep 2010, Damien Wyart uttered the following:

> * Thomas Gleixner <tglx@linutronix.de> [2010-09-15 15:11]:
>> > x86: hpet: Work around hardware stupidity
>
>> After my brain recovered from yesterdays exposure with the x86 timer
>> horror, I came up with a different solution for this problem, which
>> avoids the readback of the compare register completely. It works
>> nicely on my affected ATI system, but needs some exposure to the other
>> machines.
>
> Comments for this different solution seemed fine, but it seems only the
> first one was commited into mainline and then stable. Is this intended?

I assumed he was letting people shake the bugs out rather than inflict
what is basically just a performance improvement on -stable. For the
record: no bugs here. I also know why one of my machines was unaffected,
and it provides even more confirmation that this bug is correctly
identified, as if we needed more. It's not using the HPET at all:

Clock Event Device: cs5535-clockevt

Every single machine I owned with an HPET was affected by this bug: they
all work perfectly well now.
