Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2JAH1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:27:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51070 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JAH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:27:44 -0400
Date: Mon, 1 Oct 2012 09:27:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Bernhard Walle <bernhard@bwalle.de>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH v2] kbuild: Fix gcc -x syntax
Message-ID: <20121001072739.GC17166@gmail.com>
References: <1348924408.6962.2.camel@amber.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348924408.6962.2.camel@amber.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Delvare <jdelvare@suse.de> wrote:

> The correct syntax for gcc -x is "gcc -x assembler", not
> "gcc -xassembler". Even though the latter happens to work, the former
> is what is documented in the manual page and thus what gcc wrappers
> such as icecream do expect.
> 
> This isn't a cosmetic change. The missing space prevents icecream from
> recognizing compilation tasks it can't handle, leading to silent kernel
> miscompilations.
> 
> Besides me, credits go to Richard Guenther and Dirk Mueller for
> investigating the miscompilation issue and tracking it down to this
> incorrect -x parameter syntax.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: stable@vger.kernel.org
> Cc: Bernhard Walle <bernhard@bwalle.de>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> ---
> Changes since v1:
>  * Found more occurrences of the same. These are probably less
>    problematic in practice but let's fix them all still.
> 
>  arch/mips/Makefile                         |    2 +-
>  arch/mips/kernel/Makefile                  |    2 +-
>  arch/x86/Makefile                          |    2 +-
>  scripts/Kbuild.include                     |   12 ++++++------
>  scripts/gcc-version.sh                     |    6 +++---
>  scripts/gcc-x86_32-has-stack-protector.sh  |    2 +-
>  scripts/gcc-x86_64-has-stack-protector.sh  |    2 +-
>  scripts/kconfig/check.sh                   |    2 +-
>  scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
>  tools/perf/Makefile                        |    2 +-
>  tools/power/cpupower/Makefile              |    2 +-
>  11 files changed, 18 insertions(+), 18 deletions(-)

Acked-by: Ingo Molnar <mingo@kernel.org>

Michal, want to pick this one up into the kbuild tree?

Thanks,

	Ingo
