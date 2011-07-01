Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab1GAOyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670Ab1GAOyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:54:10 -0400
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/10] Enhance /dev/mem to allow read/write of arbitrary physical addresses
Date: Fri, 1 Jul 2011 16:54:06 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.5-default; KDE/4.6.0; i686; ; )
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201106171038.25988.ptesarik@suse.cz> <20110701144129.GA10052@infradead.org> <20110701144641.GA23272@elte.hu>
In-Reply-To: <20110701144641.GA23272@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107011654.06651.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Pá 1. července 2011 16:46:41 Ingo Molnar napsal(a):
> * Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Jul 01, 2011 at 04:37:35PM +0200, Ingo Molnar wrote:
> > > After initial modules have loaded i essentially disable crash.ko
> > > via /proc/sys/kernel/modules_disabled so rootkits have to work a
> > > bit harder than that.
> > 
> > Not sure for fedora as I don'[t have a kernel tree at hand right
> > now, but for x86 systems at least RHEL6 has the module built in.
> > [...]
> 
> Fedora Rawhide has it modular:
> 
>  # grep CRASH /boot/config-2.6.38-0.rc7.git2.3.fc16.x86_64
>  CONFIG_CRASH=m
> 
>  # rpm -ql kernel-2.6.38-0.rc7.git2.3.fc16.x86_64 | grep crash
>  /lib/modules/2.6.38-0.rc7.git2.3.fc16.x86_64/kernel/drivers/char/crash.ko
> 
> > [...]  Either way we'll need some way to support crash properly in
> > mainline, preferably in a boot-time opt-in way. [...]
> 
> Yes, boot-time opt-in was what i suggested.
> 
> > [...] I'd tend slightly toward optionally enabling /dev/mem for it
> > instead of a separate driver, but if people prefer a different
> > route I'm fine, too.
> 
> No, sharing the driver is perfectly fine and sane as long as this
> weird usage is not enabled widely.

Note that if you want to solve the Fedora case, you want to make STRICT_DEVMEM 
run-time configurable. My patch set does nothing about it. It merely tries to 
fix the highmem deficiency (actually, the first patch is a plain bugfix on any 
architecture where loff_t is larger than long).

The STRICT_DEVMEM logic is implemented in range_is_allowed(), and I leave it 
as-is.

> > Note that for normal crash usage read only access is just fine.
> 
> That's true as well. Petr?

Yes, that's true. Although there is some write support in crash, I have never 
ever felt the need to use it, and I've been using crash a lot in the last 5 
years.

Thanks,
Petr Tesarik
