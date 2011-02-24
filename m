Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab1BXRqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:46:01 -0500
Received: from mail.vyatta.com ([76.74.103.46]:51804 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1BXRp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:45:58 -0500
Date: Thu, 24 Feb 2011 09:45:56 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Anoop P.A" <anoop.pa@gmail.com>
Cc: davem@davemloft.net, khilman@deeprootsystems.com, cyril@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH] Network driver for PMC-Sierra MSP71xx TSMAC.
Message-ID: <20110224094556.6c371c38@nehalam>
In-Reply-To: <1298548660-10546-1-git-send-email-anoop.pa@gmail.com>
References: <1298548660-10546-1-git-send-email-anoop.pa@gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 17:27:40 +0530
"Anoop P.A" <anoop.pa@gmail.com> wrote:

> +#if PMC_MSP_TSMAC
> +
> +config DESC_ALL_DSPRAM
> +	bool "TX/RX Descriptors in DSPRAM"
> +	depends on DMA_TO_SPRAM
> +	default n
> +	help
> +	  Turning this on puts TX/RX descriptors in DSPRAM. Otherwise they are in
> +	  DRAM.
> +
> +config TSMAC_LINELOOPBACK_FEATURE
> +	bool "lineLoopBack command"
> +	default n
> +	help
> +	  Turning this on includes the lineLoopBack command in the driver's proc
> +	  interface.  Echoing 1 into the lineLoopBack results in all rx packets
> +	  being transmitted out the same port.
> +
> +config TSMAC_TEST_CMDS
> +	bool "test commands"
> +	default n
> +	help
> +	  Turning this on includes the testing commands in the driver's proc
> +	  interface.  These are used internally by PMC.
> +

Too many config options. Usually no config options is best, or at
most one debug option.

The proc interface for testing should be replaced with debugfs
