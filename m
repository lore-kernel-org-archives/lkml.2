Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1FGNfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:35:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab1FGNfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:35:08 -0400
Date: Tue, 7 Jun 2011 14:35:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH/RFC] m68k/bitops: Make bitmap data pointer of atomic
 ops volatile
Message-ID: <20110607133500.GX29924@decadent.org.uk>
References: <1307390873-29687-1-git-send-email-geert@linux-m68k.org>
 <201106062211.15247.arnd@arndb.de>
 <BANLkTin8XNA+ocdjUhtzVOQNxOGFsYa1mA@mail.gmail.com>
 <201106071322.29884.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201106071322.29884.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 01:22:29PM +0200, Arnd Bergmann wrote:
> On Tuesday 07 June 2011, Geert Uytterhoeven wrote:
> > You mean the host_busy variable in the IDE code?
> > That would also apply to context_flag in the DRM code:
> > 
> > drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
> > ‘__constant_test_and_set_bit’ discards qualifiers from pointer target
> > type
> > drivers/gpu/drm/drm_context.c:233: warning: passing argument 2 of
> > ‘__generic_test_and_set_bit’ discards qualifiers from pointer target
> > type
> 
> Yes, that fits the same category.
> 
> > > is wrong, though. It probably doesn't hurt to do both.
> > 
> > asm-generic/bitops/atomic.h has the volatiles everywhere. That's why
> > I'm wondering.
> 
> I guess what happened is that some variables are traditionally marked
> as volatile although they shouldn't be, and most architectures have
> adapted their bitops to make the warnings go away. If you see more
> warnings of that kind, it's probably fine to just do the same on m68k.
> The volatile modifier doesn't really hurt in this case.
 
These operations are required to be atomic and therefore they
must be suitable for use with volatile-qualified variables.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
