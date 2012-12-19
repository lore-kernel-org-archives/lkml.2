Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2LSXkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:40:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49340 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2LSXkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:40:14 -0500
Date: Thu, 20 Dec 2012 00:40:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121219234012.GO24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
	Yinghai Lu <yinghai@kernel.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-tip-commits@vger.kernel.org" <linux-tip-commits@vger.kernel.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
References: <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <20121219230329.GM24895@liondog.tnic>
 <50D24C25.5050604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50D24C25.5050604@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 03:22:13PM -0800, H. Peter Anvin wrote:

[ … ]

> Now, calming down a little bit, we are definitely dealing with BIOS
> engineers and so f*ckups are going to happen, again and again.

Yeppers.

> The only truly "safe" option is to limit early mappings to 4K pages.
> This is highly undesirable for a bunch of reasons.  Reducing mapping
> granularity to 2M rather than 1G (what Yinghai is proposing) does reduce
> the exposure somewhat; it would be interesting to gather trap statistics
> and try to get a feel for if this actually changes the boot time
> measurably or not.

This is done on the BSP, right? So we can measure it how long it takes
by taking TSC values of start and end.

> The other bit is that building the real kernel page tables iteratively
> (ignoring the early page tables here) is safer, since the real page
> table builder is fully aware of the memory map.  This means any
> "spillover" from the early page tables gets minimized to regions where
> there are data objects that have to be accessed early.

That shouldn't be a "lot", relatively speaking.

> Since Yinghai already had iterative page table building working, I
> don't see any reason to not use that capability.
> 
> Thoughts?

Sounds doable but we should take a hard look at the patches so that we
don't miss anything.

Also, I don't know how stuff like that would be approached for a wider
testing - I mean, it is a serious change in x86 boot code and there will
be issues.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
