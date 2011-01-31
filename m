Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1AaN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:28:48 -0500
Received: from www.tglx.de ([62.245.132.106]:56010 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab1AaN2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:28:47 -0500
Date: Mon, 31 Jan 2011 14:28:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: David Howells <dhowells@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [patch 1/3] mn10300: Remove stale code
In-Reply-To: <20110131131808.822602368@linutronix.de>
Message-ID: <alpine.LFD.2.00.1101311426240.31804@localhost6.localdomain6>
References: <20110131131707.795836437@linutronix.de> <20110131131808.822602368@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Thomas Gleixner wrote:

> mn10300 implements clocksource and clockevents and selects them
> unconditionally in Kconfig. Remove the stale code which seems to be a
> leftover of the conversion. Cleanup the configuration switches as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
> Cc: Mark Salter <msalter@redhat.com>
> ---
>  arch/mn10300/Kconfig         |   15 ------------
>  arch/mn10300/kernel/Makefile |    5 +---
>  arch/mn10300/kernel/time.c   |   53 -------------------------------------------
>  3 files changed, 2 insertions(+), 71 deletions(-)
> 
> Index: linux-2.6/arch/mn10300/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/mn10300/Kconfig
> +++ linux-2.6/arch/mn10300/Kconfig
> @@ -53,21 +53,6 @@ config GENERIC_TIME
>  config GENERIC_CLOCKEVENTS
>  	def_bool y
>  
> -config GENERIC_CLOCKEVENTS_BUILD
> -	def_bool y
> -	depends on GENERIC_CLOCKEVENTS
> -
> -config GENERIC_CLOCKEVENTS_BROADCAST
> -	bool
> -
> -config CEVT_MN10300
> -       def_bool y
> -       depends on GENERIC_CLOCKEVENTS
> -
> -config CSRC_MN10300
> -       def_bool y
> -       depends on GENERIC_TIME
> -

Actually that should zap GENERIC_TIME as well. It's gone since commit
592913ec.

Thanks,

	tglx
