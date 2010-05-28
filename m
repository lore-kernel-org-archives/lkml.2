Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0E1W35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:29:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab0E1W34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:29:56 -0400
Date: Fri, 28 May 2010 15:22:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Andy Green <andy@warmcat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] panic: keep blinking in spite of long spin timer mode
Message-Id: <20100528152241.4f5db28f.randy.dunlap@oracle.com>
In-Reply-To: <201005272156.AA00412@tamuki.linet.gr.jp>
References: <201005272156.AA00412@tamuki.linet.gr.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090204.4C004287.00AF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 06:56:45 +0900 TAMUKI Shoichi wrote:

> To keep panic_timeout accuracy when running under a hypervisor, the
> current implementation only spins on long time (1 second) calls to
> mdelay.  That brings a good effect, but we must give up blinking even
> if we have a panic_blink.
> 
> This patch keeps blinking in spite of long spin timer mode.
> 
> We now have new kernel parameter (panic_longspin) to enable long spin
> timer mode when kernel panics.  This is to be used when running under
> a hypervisor (default is disable).
> 
> Signed-off-by: TAMUKI Shoichi <tamuki@linet.gr.jp>
> ---
>  Documentation/kernel-parameters.txt |    7 +-
>  arch/arm/mach-s3c2440/mach-gta02.c  |   17 +----
>  drivers/input/serio/i8042.c         |   25 +-------
>  include/linux/kernel.h              |    2 
>  kernel/panic.c                      |   81 +++++++++++++++++---------
>  5 files changed, 70 insertions(+), 62 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fc89cac..7709450 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -918,9 +918,6 @@ and is between 256 and 4096 characters. It is defined in the file
>  			     controller
>  	i8042.nopnp	[HW] Don't use ACPIPnP / PnPBIOS to discover KBD/AUX
>  			     controllers
> -	i8042.panicblink=
> -			[HW] Frequency with which keyboard LEDs should blink
> -			     when kernel panics (default is 0.5 sec)
>  	i8042.reset	[HW] Reset the controller during init and cleanup
>  	i8042.unlock	[HW] Unlock (ignore) the keylock
>  
> @@ -1870,6 +1867,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	panic=		[KNL] Kernel behaviour on panic
>  			Format: <timeout>
> +	panic_longspin	[KNL] Enable long spin timer mode when kernel panics.
> +			      This is to be used when running under a hyper-
> +			      visor (default is disable)
> +	panicblink=	[KNL] The speed of panic blink (default is 12 wpm)

What is "wpm"?  In typing, it's words per minute.
Is it "winks per minute" here?  If not, what?


>  	parkbd.port=	[HW] Parallel port number the keyboard adapter is
>  			connected to, default is 0.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
