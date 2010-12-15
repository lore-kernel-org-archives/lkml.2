Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0LOS27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 13:28:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60529 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab0LOS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 13:28:55 -0500
Message-ID: <4D0908A6.6010508@zytor.com>
Date: Wed, 15 Dec 2010 10:27:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>
Subject: Re: [PATCH 5/5] PNP: HP nx6325 fixup: reserve unreported resources
References: <20101208213606.13026.47657.stgit@bob.kio> <20101215062650.GB2728@helgaas.com> <AANLkTi=U+CTn=RDvYG0w6JK0Owv_TEc9YNtAtm9DeLKi@mail.gmail.com> <201012151118.30512.bjorn.helgaas@hp.com>
In-Reply-To: <201012151118.30512.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 10:18 AM, Bjorn Helgaas wrote:
> 
> ACPI devices tend to be at high addresses, so allocating top-down
> is definitely more dangerous unless we explicitly avoid them.  I
> should have realized that and done something like patches 1-3 of
> this series before the top-down patches.
> 
> Doing it bottom-up would very likely work better than the "top-down
> without avoiding ACPI regions" model we currently have, at least in
> the short term.  We *would* have to do something to avoid E820
> reservations to fix this:
>   https://bugzilla.kernel.org/show_bug.cgi?id=16228,
> but that's doable.
> 
> So here's my proposal for .37:
>   - Keep the current state of _CRS enabled by default (for 2008
>     and newer machines).
>   - Allocate bottom-up always
>   - Avoid E820 reservations
> 
> That should fix all the regressions I'm aware of.  I'll work on
> the patches this afternoon.
> 

At the same time, I would like to see a few things done as a matter of
course:

a) reserve the top 2 MiB of the 32-bit address space.  There *will* be
ROM at the top of the 32-bit address space; it's a fact of the
architecture, and on at least older systems it was common to have a
shadow 1 MiB below.

b) we may want to consider doing special things in the 0xFExxxxxx memory
range, which is used by the CPU-APIC-MSI system in recent processors.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

