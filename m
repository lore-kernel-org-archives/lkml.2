Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab2LSUiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:38:05 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32845 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2LSUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:37:56 -0500
Date: Wed, 19 Dec 2012 21:37:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
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
Message-ID: <20121219203751.GG24895@liondog.tnic>
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
References: <CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
 <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
 <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
 <50CCCFD0.7030704@linux.intel.com>
 <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
 <50CCEE49.3080801@zytor.com>
 <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
 <50CCF6F6.4020107@zytor.com>
 <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
 <50CD04F1.8020902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CD04F1.8020902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 03:17:05PM -0800, H. Peter Anvin wrote:
> On 12/15/2012 03:15 PM, Yinghai Lu wrote:
> >>
> >>That is for the kernel region itself (that code is actually unchanged from
> >>the current code), and yes, we could cap that one to _end if there are
> >>systems which have bugs in that area.  The dynamic page tables map 1G
> >>aligned at a time.
> >
> >dynamic should be 2M too.
> >
> >AMD system:
> >
> >http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=66520ebc2df3fe52eb4792f8101fac573b766baf
> >
> >  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
> >  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
> >  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> >
> >the hole is not 1G aligned.
> >
> >or HT region is from e040000000 ?
> >
> 
> The HT region starts at 0xfd00000000 -- after that reserved region,
> so I have no idea what that particular system is trying to do or
> what is requirements are (nor what its MTRR setup is, since you
> didn't post it.)

This is something that Jacob should be able to answer since he's been
dealing with the 1T support.

Jacob, how is the HT hole marked on AMD? I know hazily that we do say
"all memory regions cacheable by default if not explicitly marked" but
we need to exclude the HT hole from that, right?

So how are we doing that, MTRRs?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
