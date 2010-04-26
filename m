Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0DZPmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 11:42:00 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:44029 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0DZPl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 11:41:58 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "R. Andrew Bailey" <bailey@akamai.com>
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
Date: Mon, 26 Apr 2010 09:40:48 -0600
User-Agent: KMail/1.9.10
Cc: Andy Isaacson <adi@hexapodia.org>, Yinghai <yinghai.lu@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
References: <4BC4E55B.7000103@oracle.com> <201004231705.25659.bjorn.helgaas@hp.com> <20100426125032.GA1623@akamai.com>
In-Reply-To: <20100426125032.GA1623@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004260940.52478.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010 06:50:32 am R. Andrew Bailey wrote:
> On 23/04/10 17:05 -0600, Bjorn Helgaas wrote:
> >On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
> >Would you guys (Andy & Andy, what a coincidence :-)) mind giving
> >it a try?  This is intended to work on top of current upstream,
> >with no other patches required.
> >
> Good news- that solved it. I tried Yinghai's patches saturday to no
> avail (sorry it took me so long to get back to you, I was about 5 bios
> revisions behind on this machine and wanted to update it before I
> tried any more tests).

Great, thanks for testing this!  The only problem here is that we
changed two things at once -- the BIOS and the patch, and we need
to figure out which change fixed the problem.

I want Linux to work correctly even on the old BIOS, on the theory
that "if Windows works, Linux should work, too."  Changing a BIOS
is relatively risky, and it's not something I want users to have to
diagnose and deal with.

If we're lucky, the kernel without the patch will still fail on the
updated BIOS.  If the pre-patch kernel fails and the post-patch kernel
works, and you can attach the entire dmesg log of the post-patch kernel
to the bugzilla, we should be able to see Linux making more sensible
BAR assignments when working around the BIOS bug.  Then we can be pretty
confident that my patch fixed the problem.

If the pre-patch kernel works on the updated BIOS, that means one of
the BIOS updates fixed the BIOS bug, and we didn't actually exercise
my patch at all.  If that's the case, we'll have to wait for a report
from the other Andy.  (Or you could temporarily down-grade your BIOS
to the original version you had.  But I don't know whether that's even
possible...  it probably depends on the BIOS update tools.)

Thanks again for all your help.  All progress in Linux depends on early
adopters like you who are willing to test kernels and help work through
issues :-)

Bjorn
