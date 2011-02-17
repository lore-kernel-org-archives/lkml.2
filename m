Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1BQRce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:32:34 -0500
Received: from [65.115.85.73] ([65.115.85.73]:50279 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab1BQRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:32:32 -0500
Date: Thu, 17 Feb 2011 09:31:36 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
Message-ID: <20110217173136.GA28486@dtor-ws.eng.vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
 <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 09:24:58AM -0800, Linus Torvalds wrote:
> On Mon, Feb 7, 2011 at 4:02 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> >
> > Moreover, as DaveM said, we can't reliably put structures into
> > independent objects, put them into a special section, and then expect
> > array access over them (via the section boundaries) after linking the
> > objects together to just "work" due to variable alignment choices in
> > different situations.
> 
> Why not?
> 
> That's what we normally do. Just align the "__modver", and you should
> be all good. What's the problem?

>From what I understand __attribute__ ((aligned(x))) only guarantees
minimum alignment, not exact (gapless) alignment. GCC seems to lay out
pointers in the section without gaps on all arches that we have.

Thanks.

-- 
Dmitry

