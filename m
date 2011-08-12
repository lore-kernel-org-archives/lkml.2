Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1HLUzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 16:55:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1HLUzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 16:55:45 -0400
Date: Fri, 12 Aug 2011 21:55:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: Skip relinking if nothing changes
Message-ID: <20110812205520.GL4775@n2100.arm.linux.org.uk>
References: <4E457682.5020107@codeaurora.org> <1313175602-21834-1-git-send-email-sboyd@codeaurora.org> <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MUq5M-XPOxV=8GKyEzjEzpmdeaF+mGrXJrK+ZZxa4SdeQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 04:48:12PM -0400, Arnaud Lacombe wrote:
> You should be able to avoid the extra copy altogether by doing something ala:
> 
> $(obj)/lib1funcs.o: $(srctree)/arch/arm/lib/lib1funcs.S
>         $(call cmd,as_o_S)
> 
> note that I also remove the $(SRCARCH), as there is no other
> `arch/*/lib/lib1funcs.S' than `arch/arm/lib/lib1funcs.S'

We tried such things, but it results in kbuild arguing over building
lib1funcs.S in arch/arm/lib and arch/arm/boot/compressed.  You end up
with it rebuilding the arch/arm/lib one, followed by a rebuild of the
arch/arm/boot/compressed one.

We've ended up with what we have because its about the only way to get
kbuild to behave.
