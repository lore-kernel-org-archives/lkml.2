Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0LVVBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:01:30 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:22976
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751213Ab0LVVB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:01:29 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK1432N98dNzz1202hzz8275bhz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D1266F5.8040702@am.sony.com>
Date: Wed, 22 Dec 2010 13:00:37 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Prevent users from disabling tickless
References: <20101221233942.GL1263@parisc-linux.org>
In-Reply-To: <20101221233942.GL1263@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/10 15:39, Matthew Wilcox wrote:
> 
> Disabling NO_HZ has a serious negative effect on performance -- an extra
> 70us per I/O.  Prevent users from deselecting it.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index f06a8a3..55b9a04 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -5,13 +5,9 @@ config TICK_ONESHOT
>  	bool
>  
>  config NO_HZ
> -	bool "Tickless System (Dynamic Ticks)"
> +	def_bool y
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
>  	select TICK_ONESHOT
> -	help
> -	  This option enables a tickless system: timer interrupts will
> -	  only trigger on an as-needed basis both when the system is
> -	  busy and when the system is idle.
>  
>  config HIGH_RES_TIMERS
>  	bool "High Resolution Timer Support"

Why remove the ability to make the configuration choice?  Why not
just add the info about performance impact to the help text and
let me shoot myself in the foot (that is the unix way (tm)) if
I desire to?

(Yes I say your later reply about the kernel command line method
of shooting myself in the foot.)

-Frank


