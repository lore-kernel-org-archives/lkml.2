Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935050Ab0KQRQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 12:16:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36233 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935027Ab0KQRQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 12:16:38 -0500
Date: Wed, 17 Nov 2010 17:16:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/20] ARM: LPAE: Introduce L_PTE_NOEXEC and
	L_PTE_NOWRITE
Message-ID: <20101117171613.GB5308@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-6-git-send-email-catalin.marinas@arm.com> <20101115183014.GD31421@n2100.arm.linux.org.uk> <AANLkTik5FcZ3rNtiwN8kYP0LZh+YqGtKP_RteoFiWa16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik5FcZ3rNtiwN8kYP0LZh+YqGtKP_RteoFiWa16@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 05:02:37PM +0000, Catalin Marinas wrote:
> On 15 November 2010 18:30, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Nov 12, 2010 at 06:00:25PM +0000, Catalin Marinas wrote:
> >> --- a/arch/arm/include/asm/pgtable-2level.h
> >> +++ b/arch/arm/include/asm/pgtable-2level.h
> >> @@ -128,6 +128,8 @@
> >>  #define L_PTE_USER           (1 << 8)
> >>  #define L_PTE_EXEC           (1 << 9)
> >>  #define L_PTE_SHARED         (1 << 10)       /* shared(v6), coherent(xsc3) */
> >> +#define L_PTE_NOEXEC         (0)
> >> +#define L_PTE_NOWRITE                (0)
> >
> > Let's not make this more complicated than it has to be.  If we need the
> > inverse of WRITE and EXEC, then that's what we should change everyone to,
> > not invent a new system to work along side the old system.
> 
> Question on the pgprot_noncached/writecombine/dmacoherent - in the
> current implementation we pass L_PTE_EXEC on the dmacoherent macro.

Erm.  Please look at the code again.
