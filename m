Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab0KOWrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:47:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab0KOWrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:47:11 -0500
Date: Mon, 15 Nov 2010 23:46:45 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jim Bos <jim876@xs4all.nl>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115224645.GI29412@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl>
 <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
 <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
 <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
 <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
 <20101115224322.GA1303@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115224322.GA1303@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:43:22PM +0100, Andi Kleen wrote:
> > testcase shows that in 4.1/4.2/4.3/4.4 this is miscompiled only when using
> > -fno-ipa-reference, in 4.5 it is miscompiled always when optimizing
> > unless -fno-ipa-pure-const (as 4.5 added local-pure-const pass which is run
> > before ipa-reference) and in 4.6 this has been fixed by Honza when
> > doing ipa cleanups.
> 
> Maybe it would be better to simply change the kernel Makefiles to pass
> -fno-ipa-pure-const instead of adding volatiles everywhere.

If you do this, please do it for 4.5.[012] only.  If you disable all gcc
passes that ever had any bugs in it, you'd need to disable most of them if
not all.

	Jakub
