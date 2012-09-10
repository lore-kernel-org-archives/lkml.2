Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2IJPUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:20:08 -0400
Received: from smtp-out-024.synserver.de ([212.40.185.24]:1084 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2IJPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:20:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29378
Message-ID: <504E0542.8020309@metafoo.de>
Date: Mon, 10 Sep 2012 17:20:34 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Antony Pavlov <antonynpavlov@gmail.com>,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: Re: [PATCH v2 0/3] MIPS: JZ4740: Move PWM driver to PWM framework
References: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1347278719-15276-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 02:05 PM, Thierry Reding wrote:
> Hi,
> 

I think v2 looks, good. Will give it some testing later.

> This small series fixes a build error due to a circular header
> dependency, exports the timer API so it can be used outside of
> the arch/mips/jz4740 tree and finally moves and converts the
> JZ4740 PWM driver to the PWM framework.
> 
> Note that I don't have any hardware to test this on, so I had to
> rely on compile tests only. Patches 1 and 2 should probably go
> through the MIPS tree, while I can take patch 3 through the PWM
> tree. It touches a couple of files in arch/mips but the changes
> are unlikely to cause conflicts.

Patch 2 and 3 should probably go through the same tree since patch 3 depends
on patch 2. I'd like to see them both go through the PWM tree.

Patch 1 should go through the MIPS tree, but I still can't see why the issue
should occur nor does it happen for anybody else except for you. Instead of
moving the content over to the public irq.h I'd rather like to see the
private irq.h being renamed.

Thanks,
- Lars

> 
> Thierry
> 
> Thierry Reding (3):
>   MIPS: JZ4740: Break circular header dependency
>   MIPS: JZ4740: Export timer API
>   pwm: Add Ingenic JZ4740 support
> 
>  arch/mips/include/asm/mach-jz4740/irq.h      |   5 +
>  arch/mips/include/asm/mach-jz4740/platform.h |   1 +
>  arch/mips/include/asm/mach-jz4740/timer.h    | 113 ++++++++++++++
>  arch/mips/jz4740/Kconfig                     |   3 -
>  arch/mips/jz4740/Makefile                    |   2 +-
>  arch/mips/jz4740/board-qi_lb60.c             |   1 +
>  arch/mips/jz4740/irq.h                       |  23 ---
>  arch/mips/jz4740/platform.c                  |   6 +
>  arch/mips/jz4740/pwm.c                       | 177 ---------------------
>  arch/mips/jz4740/time.c                      |   2 +-
>  arch/mips/jz4740/timer.c                     |   4 +-
>  arch/mips/jz4740/timer.h                     | 136 -----------------
>  drivers/pwm/Kconfig                          |  12 +-
>  drivers/pwm/Makefile                         |   1 +
>  drivers/pwm/pwm-jz4740.c                     | 221 +++++++++++++++++++++++++++
>  15 files changed, 363 insertions(+), 344 deletions(-)
>  delete mode 100644 arch/mips/jz4740/irq.h
>  delete mode 100644 arch/mips/jz4740/pwm.c
>  delete mode 100644 arch/mips/jz4740/timer.h
>  create mode 100644 drivers/pwm/pwm-jz4740.c
> 

