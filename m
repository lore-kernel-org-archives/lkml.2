Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab1CaOge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:36:34 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:43346 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab1CaOgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:36:31 -0400
X-Greylist: delayed 1051 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 10:36:31 EDT
Message-ID: <4D948D52.4040708@grupopie.com>
Date: Thu, 31 Mar 2011 15:18:58 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> [...]
> I personally think KALLSYMS_ALL should be just merged with KALLSYMS and
> disappear - we should have only one option. CONFIG_KALLSYMS_EXTRA_PASS should
> die as well.

That sounds a little too extreme...

KALLSYMS is useful for most kernels, since it provides nice readable
stack dumps for panics and BUG's.

KALLSYMS_ALL adds a lot of extra symbols that can be useful mostly to
development kernels and shouldn't be used to add unnecessary bloat to
user kernels.

Now as for CONFIG_KALLSYMS_EXTRA_PASS: to build the kallsyms table, the
build process first links a kernel image with an empty kallsyms table
and use that to fetch information for all the symbols.

It then uses that information to build the table with the right size,
and links it again. If everything goes ok, this new version as all the
symbols in the correct places and the final table can be built with the
correct addresses.

The final linking should produce the same result as only the data on the
kallsyms table changed, but not its size.

However, there have been bugs in the past with section alignments and
symbol reordering for symbols with the same address, etc., etc. that
make this final table not have the exact same size, and the build fails
with an inconsistent kallsyms data message. At this point, the user can
turn on the CONFIG_KALLSYMS_EXTRA_PASS and temporarily solve the problem
while the developers find the correct fix. Without this option, in this
situation the kernel would simply fail the compilation.

All this has been stable for a while and this option hasn't been needed
recently (AFAIK), but if there is some bug in some new binutils or
something, the option might be needed again.

-- 
Paulo Marques - www.grupopie.com

"Who is general Failure and why is he reading my disk?"
