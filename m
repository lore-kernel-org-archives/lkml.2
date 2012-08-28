Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2H1Uo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:44:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43628 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2H1Uo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:44:57 -0400
Date: Tue, 28 Aug 2012 13:45:02 -0700
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] msm fixes for v3.6
Message-ID: <20120828204502.GA24149@quad.lixom.net>
References: <20120828165532.GA20947@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120828165532.GA20947@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 28, 2012 at 09:55:32AM -0700, David Brown wrote:
> The following changes since commit 28a33cbc24e4256c143dce96c7d93bf423229f92:
> 
>   Linux 3.5 (2012-07-21 13:58:29 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-fix-for3.6
> 
> for you to fetch changes up to e7501de53aa1a551526872f6c95901a00705f942:
> 
>   ARM: msm: Remove call to missing FPGA init on 8660 (2012-08-28 09:39:28 -0700)
> 
> ----------------------------------------------------------------
> Fixes for two problems with MSM:
> 
>   - Mapping issue on 7x00 targets.
>   - Compilation problems with devicetree on 8660.

Thanks for using a tag with a description of the pull request contents,
but it seems like you're missing a bit here -- it has a patch for the dtbs
target, and the handle_irq fix isn't technically breaking compilation,
I believe?

> ----------------------------------------------------------------
> David Brown (1):
>       ARM: msm: Remove call to missing FPGA init on 8660

So, this seems to be breaking builds, seems appropriate as a fix.

> Rohit Vaswani (2):
>       ARM: msm: io: Remove 7x30 iomap region from 7x00
>       ARM: msm: io: Change the default static iomappings to be shared

These two patches lack your Signed-off-by, even though you seem to have been
the committer. Please add it.

But also, it's not clear to me if the second of the two patches actually causes
problems, or if it's just that the mapping won't be reused from the static
range. If it's the latter, then I'd say it's 3.7 material instead. Also see my
separate comment on the posted patch about the format of it.

> Stephen Boyd (2):
>       ARM: msm: Add handle_irq handler for 8660 DT machine

Clearly a bug fix, no problem.

>       ARM: msm: Add msm8660-surf.dts to Makefile.boot

This one looks like 3.7 material.


-Olof
