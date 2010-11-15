Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933166Ab0KORgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:36:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45688 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933112Ab0KORgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:36:31 -0500
Date: Mon, 15 Nov 2010 17:36:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long
	for 32-bit ptes
Message-ID: <20101115173606.GA31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-4-git-send-email-catalin.marinas@arm.com> <20101114131941.GA10871@n2100.arm.linux.org.uk> <AANLkTimtSUNrO0wZBfyJJ+OJQCDLkXSOiUuzOD+ubv6O@mail.gmail.com> <AANLkTi=U+5uqLRSt9ObFdgTUc-v_+2Y3Qz90FG5aRTyb@mail.gmail.com> <20101114151445.GB10871@n2100.arm.linux.org.uk> <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:39:30AM +0000, Catalin Marinas wrote:
> On 14 November 2010 15:14, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > There will be compiler warnings because u32 is unsigned int, and we
> > print it as %08lx.  Generic code cases pte values to (long long) and
> > prints them using %08llx.  We should do the same.
> 
> We still need some kind of macro because with LPAE we need %016llx
> since the phys address can go to 40-bit and there are some additional
> bits in the top word. Unless you'd like to always print 16 characters
> even for 32-bit ptes (or if there is some other printk magic I'm not
> aware of).

Eeh?  %08llx prints 8 characters _minimum_.  If it needs more to represent
the number, it will use more characters.  You surely don't think generic
code is brain dead enough to cast something to a 64-bit long long and
then only print 32 bits of it???
