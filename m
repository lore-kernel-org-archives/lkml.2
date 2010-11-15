Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab0KOWn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:43:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37756 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab0KOWn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:43:26 -0500
Date: Mon, 15 Nov 2010 23:43:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jim Bos <jim876@xs4all.nl>,
        Andi Kleen <andi@firstfloor.org>, James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115224322.GA1303@one.firstfloor.org>
References: <20101115105446.GD7269@basil.fritz.box> <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com> <4CE17098.8090000@xs4all.nl> <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com> <4CE17C4B.1070305@xs4all.nl> <20101115185848.GI2583@sunsite.ms.mff.cuni.cz> <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com> <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> testcase shows that in 4.1/4.2/4.3/4.4 this is miscompiled only when using
> -fno-ipa-reference, in 4.5 it is miscompiled always when optimizing
> unless -fno-ipa-pure-const (as 4.5 added local-pure-const pass which is run
> before ipa-reference) and in 4.6 this has been fixed by Honza when
> doing ipa cleanups.

Maybe it would be better to simply change the kernel Makefiles to pass
-fno-ipa-pure-const instead of adding volatiles everywhere.

-Andi
