Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab0EWXCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:02:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45738 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab0EWXCH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U2smcdoSbwKvUQf7mbym5KMkCGHNV8AWo1hsQs8X/gm8pdKBXZfYqY+Jw7EFLNjYt3
         RgHLDqt6cwGKeWGVTyfKRjvYJHpdM8ExQ1dVnHnycqvZfHOl2L3BgM6QMATMR4D+V9zb
         JdzARe1aT7CdUURUCsIByTB5OSV25apTBXrqs=
MIME-Version: 1.0
In-Reply-To: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
References: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
Date: Sun, 23 May 2010 16:02:05 -0700
X-Google-Sender-Auth: KIap7V9hsMQX4Mvj1rFYKogTMbA
Message-ID: <AANLkTikmdqceeWNYGm7ZTI64pixtkVWBbpWEtajZGHA1@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
From: Dan Williams <dan.j.williams@intel.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 12:49 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This completes the DMA40 support with the platform-specific
> configuration for U8500/DB8500.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Reviewed-by: Alessandro Rubini <rubini@unipv.it>
> Cc: STEricsson_nomadik_linux@list.st.com
> ---
> Dan, now that Russells depending patches from the ARM tree have
> been merged to Linus' (Torvalds) tree, do you think it's possible
> to also push this DMA40 platform data through the async_tx tree?
> This is the final version of it.
> ---
>  arch/arm/mach-ux500/clock.c                    |    2 +-
>  arch/arm/mach-ux500/cpu-db8500.c               |    4 +
>  arch/arm/mach-ux500/devices-db8500.c           |  219 ++++++++++++++++++++++++
>  arch/arm/mach-ux500/include/mach/db8500-regs.h |   12 ++
>  arch/arm/mach-ux500/include/mach/devices.h     |    3 +
>  arch/arm/mach-ux500/ste-dma40-db8500.h         |  154 +++++++++++++++++
>  6 files changed, 393 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/mach-ux500/ste-dma40-db8500.h
>

Russell, I will be sending one more pull request for this merge window
and plan to include this with your acked-by.  It finishes off the
support for the dma40 driver.

There are two straggling patches that cross depended on the arm and
dmaengine trees.

Jassi Brar (1):
      DMA: PL330: Add dma api driver

Linus Walleij (1):
      DMAENGINE: DMA40 U8500 platform configuration

 arch/arm/mach-ux500/clock.c                    |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c               |    4 +
 arch/arm/mach-ux500/devices-db8500.c           |  219 ++++++
 arch/arm/mach-ux500/include/mach/db8500-regs.h |   12 +
 arch/arm/mach-ux500/include/mach/devices.h     |    3 +
 arch/arm/mach-ux500/ste-dma40-db8500.h         |  154 +++++
 drivers/dma/Kconfig                            |    9 +
 drivers/dma/Makefile                           |    1 +
 drivers/dma/pl330.c                            |  866 ++++++++++++++++++++++++
 include/linux/amba/pl330.h                     |   45 ++
 10 files changed, 1314 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-ux500/ste-dma40-db8500.h
 create mode 100644 drivers/dma/pl330.c
 create mode 100644 include/linux/amba/pl330.h

--
Dan
