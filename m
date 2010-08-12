Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218Ab0HLPAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:00:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61189 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0HLPAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:00:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: uaccess: Implement strict user copy checks
Date: Thu, 12 Aug 2010 17:00:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
References: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org> <201008110504.59957.arnd@arndb.de> <4C62F01E.2000708@codeaurora.org>
In-Reply-To: <4C62F01E.2000708@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008121700.28085.arnd@arndb.de>
X-Provags-ID: V02:K0:zB/krX+MFZI8kOqQIXt+hoK21I92lxqYzxGwLzIP20b
 QRz9MDjwj/SzG8X8olpLV0yjtFchI5YsP/k98qx4HzDVdjMU+r
 CYNuWkgSHq5xW/Fz1i+QmMdMnRyur40O20elE6AVxVvKopZqIH
 sNuo7qUogKQmMug2jgfrtWKddyRzOWKy28nT6hziTRP9roYMk1
 RcUvS9TK3uqtGPDwijQjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 August 2010, Stephen Boyd wrote:
> On 08/10/2010 08:04 PM, Arnd Bergmann wrote:
> >
> > Do you actually need to disable this if running an older gcc? AFAICT, it
> > should just have no effect at all in that case, so the comment is slightly
> > misleading.
> 
> I blindly copied the help text from x86. Will fix to be less misleading.

Ok, I didn't realize that x86 is also doing this as an optional error.
My comment was obviously not about your copy then but about the
comment in general. Since it would be good to diverge, please
leave the patch as it is then and do a new patch that fixes the
message on all architectures at the same time.

> > Also, why turn this specific warning into an error but not any of the other
> > warnings? Some architectures (alpha, sparc, mips, powerpc, sh) simply turn
> > on -Werror for architecture specific code in general, which seems very
> > useful. We can also make that a config option (probably arch independent)
> > that we turn on for defconfig files that we know build without warnings.
> >
> > Unfortunately, there is a number of device drivers that have never been
> > warning-free, so we can't just enable -Werror for all code.
> >
> 
> I'm following the x86 implementation. I suppose it's done this way since 
> many drivers aren't warning free (as you mention) and turning on -Werror 
> will make it more annoying to find these types of errors. Since there 
> isn't any -Werror=user-copy this approach allows us to find this type of 
> error easily without having to sift through noise.
> 
> Enabling -Werror in architecture specific code wouldn't help much here 
> though right since this is going to be inlined into drivers and such?

My point was that I don't think we should single out this particular
warning and make it an error, while there are other equally important
warnings.

Again, this is directed more at the original code from Arjan than your
copy for the ARM architecture. I agree that it may be helpful to turn
more warnings into errors, but I don't think we should do this on 
this level of detail (one Kconfig option per warning).

Your patch should just go in unmodified, but I'd also suggest generalizing
this a bit more on all architectures.

	Arnd
