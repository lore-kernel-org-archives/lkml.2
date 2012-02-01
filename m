Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2BAHyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:54:50 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42454 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab2BAHyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:54:49 -0500
Date: Tue, 31 Jan 2012 23:54:48 -0800
From: Olof Johansson <olof@lixom.net>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Message-ID: <20120201075448.GI7399@quad.lixom.net>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-4-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328028051-24271-4-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:40:41PM +0200, Peter De Schrijver wrote:

> +	.align L1_CACHE_SHIFT
> +	.type	__tegra_cpu_reset_handler_data, %object
> +	.globl	__tegra_cpu_reset_handler_data
> +__tegra_cpu_reset_handler_data:
> +	.rept	TEGRA_RESET_DATA_SIZE
> +	.long	0
> +	.endr
> +	.size	__tegra_cpu_reset_handler_data, .-tegra_cpu_reset_handler_data
> +	.align L1_CACHE_SHIFT
> +

This doesn't build:

/tmp/ccPd4Pcj.s: Assembler messages:
/tmp/ccPd4Pcj.s: Error: .size expression for __tegra_cpu_reset_handler_data does not evaluate to a constant

Did you mean .-__tegra_cpu_reset_handler_data there?

-Olof
