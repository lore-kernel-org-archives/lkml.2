Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab2GFLv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:51:59 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:35565 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab2GFLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:51:57 -0400
X-Greylist: delayed 2044 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 07:51:56 EDT
Message-ID: <4FF6C958.9090809@grupopie.com>
Date: Fri, 06 Jul 2012 12:17:44 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Jan Beulich <jbeulich@novell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Inconsistent kallsyms data" error
References: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
In-Reply-To: <CA+55aFyr+gexQW9Gmg=_V145SUeKOcfSNUx5h4p7bgjMp=07Og@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> [...]
> Notice how 'kallsyms_addresses' has the same value, but
> 'kallsyms_num_syms' (and subsequent symbols until the page-aligned
> __end_rodata symbol that gets them back in sync) do not. I have no
> idea *why* this happens, but it definitely does.
> 
> It seems the real difference is the size of the "kallsyms_addresses"
> data structure. No idea why, though.
> 
> This happens with current git (commit c4aed353b1b0), on an x86-64
> machine running current F17 as of today, with the attached config.
> Maybe that makes somebody else able to recreate this and figure out
> what is so magical about the layout that the exact kernel version and
> config (and likely compiler/binutils versions) matter.
> 
> Any ideas? Added a fairly random set of people who get mentioned in
> the linker script commits etc.

Since kallsyms_addresses seems to change size, this means that there
were symbols added in the second pass.

In the past, this usually happened when some symbols are near a section
boundary and the alignment makes them included or excluded from the
kernel symbol tables.

There was a recent thread from David Brown on the arm linux mailing list
("ARM: two possible fixes for the KALLSYMS build problem"). He tracked
down the problem to having empty per_cpu sections on a non-smp build.
The alignment of these sections made the symbols jump around and change
from one build to the next. This particular problem might be ARM
specific, though.

-- 
Paulo Marques - www.grupopie.com

"I used to be indecisive, but now I'm not so sure."
