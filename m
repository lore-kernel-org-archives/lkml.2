Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab0KONpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:45:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35347 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756453Ab0KONpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:45:13 -0500
Date: Mon, 15 Nov 2010 13:43:25 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: [PATCH -next] x86/mrst: force support code to be built
Message-ID: <20101115134325.199ab1f3@lxorguk.ukuu.org.uk>
In-Reply-To: <20101113084437.a9707260.randy.dunlap@oracle.com>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
	<20101113084437.a9707260.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Nov 2010 08:44:37 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix mrst.c build: make sure that its called functions are built.
> 
> arch/x86/built-in.o: In function `mrst_reboot':
> mrst.c:(.text+0x2250b): undefined reference to `intel_scu_ipc_simple_command'
> arch/x86/built-in.o: In function `mrst_power_off':
> mrst.c:(.text+0x2252e): undefined reference to `intel_scu_ipc_simple_command'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101112.orig/arch/x86/Kconfig
> +++ linux-next-20101112/arch/x86/Kconfig
> @@ -387,6 +387,7 @@ config X86_MRST
>  	select APB_TIMER
>  	select I2C
>  	select SPI
> +	select X86_PLATFORM_DEVICES

We need the SCU so in fact we really want to select that. I'll send a
patch to Ingo.
