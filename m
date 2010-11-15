Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab0KORkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:40:03 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49191 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932988Ab0KORkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:40:02 -0500
Subject: Re: [PATCH v2 03/20] ARM: LPAE: use u32 instead of unsigned long
 for 32-bit ptes
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20101115173606.GA31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	 <1289584840-18097-4-git-send-email-catalin.marinas@arm.com>
	 <20101114131941.GA10871@n2100.arm.linux.org.uk>
	 <AANLkTimtSUNrO0wZBfyJJ+OJQCDLkXSOiUuzOD+ubv6O@mail.gmail.com>
	 <AANLkTi=U+5uqLRSt9ObFdgTUc-v_+2Y3Qz90FG5aRTyb@mail.gmail.com>
	 <20101114151445.GB10871@n2100.arm.linux.org.uk>
	 <AANLkTinuUCYMa8e7=ehhExFzBAhPZBKA16M1GVQ=RMMH@mail.gmail.com>
	 <20101115173606.GA31421@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 15 Nov 2010 17:39:37 +0000
Message-ID: <1289842777.20612.84.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2010 17:39:38.0240 (UTC) FILETIME=[13600800:01CB84EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 17:36 +0000, Russell King - ARM Linux wrote:
> On Mon, Nov 15, 2010 at 09:39:30AM +0000, Catalin Marinas wrote:
> > On 14 November 2010 15:14, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > There will be compiler warnings because u32 is unsigned int, and we
> > > print it as %08lx.  Generic code cases pte values to (long long) and
> > > prints them using %08llx.  We should do the same.
> >
> > We still need some kind of macro because with LPAE we need %016llx
> > since the phys address can go to 40-bit and there are some additional
> > bits in the top word. Unless you'd like to always print 16 characters
> > even for 32-bit ptes (or if there is some other printk magic I'm not
> > aware of).
> 
> Eeh?  %08llx prints 8 characters _minimum_.  If it needs more to represent
> the number, it will use more characters.  You surely don't think generic
> code is brain dead enough to cast something to a 64-bit long long and
> then only print 32 bits of it???

That's correct. I was just wondering whether the alignment would look
weird with ptes being printed with different lengths.

Anyway, here comes another set of patches with this update (%08llx in
printk).

-- 
Catalin

