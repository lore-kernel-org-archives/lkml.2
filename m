Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1DGNSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:18:37 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45612 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777Ab1DGNSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:18:35 -0400
Date: Thu, 7 Apr 2011 09:18:10 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: oskar.andero@sonyericsson.com
Cc: linux@arm.linux.org.uk, nicolas.pitre@linaro.org, will.deacon@arm.com,
        eric.y.miao@gmail.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Victor Boivie <victor.boivie@sonyericsson.com>
Subject: Re: [PATCH] ARM: Allow for kernel command line concatenation
Message-ID: <20110407131810.GA6450@elliptictech.com>
References: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302164236-1516-1-git-send-email-oskar.andero@sonyericsson.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-07 10:17 +0200, oskar.andero@sonyericsson.com wrote:
> From: Victor Boivie <victor.boivie@sonyericsson.com>
> 
> This patch allows the provided CONFIG_CMDLINE to be concatenated
> with the one provided by the boot loader. This is useful to
> merge the static values defined in CONFIG_CMDLINE with the
> boot loader's (possibly) more dynamic values, such as startup
> reasons and more.

This sounds very useful!  One comment below.

> Signed-off-by: Victor Boivie <victor.boivie@sonyericsson.com>
> Reviewed-by: Bjorn Andersson <bjorn.andersson@sonyericsson.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonyericsson.com>
> ---
>  arch/arm/Kconfig        |   21 +++++++++++++++++++--
>  arch/arm/kernel/setup.c |    9 ++++++++-
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
[...]
> +config CMDLINE_EXTEND
> +	bool "Extend bootloader kernel arguments"
> +	depends on CMDLINE != ""
> +	help
> +	  The default kernel command string will be concatenated with the
> +	  arguments provided by the boot loader.

Since concatenation is not commutative, this help text should describe
exactly the order in which the arguments are concatenated.  How about
this instead:

  The command-line arguments provided by the boot loader will be
  appended to the default kernel command string.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
