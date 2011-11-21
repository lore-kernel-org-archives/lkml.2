Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1KUOcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:32:31 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:35927 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab1KUOca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:32:30 -0500
Date: Mon, 21 Nov 2011 15:32:26 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111121143226.GA16969@nomi.cz>
References: <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz> <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <20111121130527.GA4010@redhat.com> <20111121130916.GA11136@nomi.cz> <20111121134056.GB4010@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111121134056.GB4010@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Nov 21, 2011 at 02:40:57PM +0100, Stanislaw Gruszka wrote:
> On Mon, Nov 21, 2011 at 02:09:16PM +0100, Tomáš Janoušek wrote:
> > And that's exactly what happens if I don't disable firewire-ohci, because of
> > that stupid Ricoh multifunction blah blah issue.
> 
> So maybe problem is caused by Ricoh, not by iwlagn. But if so 
> why blacklisting iwlagn help? Wired. Did you disable firewire in
> BIOS, or just blacklist module?

I don't think so. The problem with Ricoh is that it has two PCI devices:
0d:00.0 and 0d:00.3, but both use 0d:00.0 in DMA requests, which triggers DMAR
faults.  Of course, I can try disabling that in BIOS, but I doubt it will
change anything.

> Ok maybe let's try to find some better reproducer first.
> I wrote simple program that fill memory with some pattern, and
> then check every one second if pattern is still there.
> It can be used like:
> ./checkmem 100M 30M
> where first argument is size of memory it will alloc and check,
> second specify number of internal loops to make cpu busy (bigger
> value will cause more cpu power consumption). Many instances of
> the program can be running at once.
> 
> Tomáš, please try to reproduce with that program, I'm attaching
> it. When corruption will be detected, checkmem will print invalid
> values, maybe would be possible to find out what contents is
> written to memory.

Okay, I'll try that later. Yesterday I tried to use memtester [1] to catch the
problem, but it never occured in it. Kernel compilation was segfaulting and
that tool was running alongside being all happy. But maybe it has different
memory usage pattern or something. Anyway, I'll try your program and if it
doesn't work, I'll make it so. :-)

[1] http://pyropus.ca/software/memtester/

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
