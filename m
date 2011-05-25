Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1EYMsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:48:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50932 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1EYMsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:48:31 -0400
Date: Wed, 25 May 2011 14:47:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Valdis.Kletnieks@vt.edu, "Eric W. Biederman" <ebiederm@xmission.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
Message-ID: <20110525124741.GC29300@elte.hu>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
 <BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
 <m1boyvpo9r.fsf@fess.ebiederm.org>
 <1306048393.4092.8.camel@mulgrave.site>
 <20110522084224.GA12279@elte.hu>
 <m1k4dgr35i.fsf@fess.ebiederm.org>
 <20110524071628.GA31612@elte.hu>
 <4508.1306283693@localhost>
 <20110525082514.GE21552@elte.hu>
 <BANLkTikVDrU7Nx6143gPuB=1vwqkMFiRiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikVDrU7Nx6143gPuB=1vwqkMFiRiQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > But at least the primary, 'native' syscall table of every arch 
> > could be kept rather fresh via generic enumeration.
> 
> So we can start all over at offset 501 (alpha just started using 
> 500) with a unified, clean, and compressed list of syscalls? Or do 
> we have some more other-os-compat syscalls around in this range?

No, that would leave a big hole in the syscall table of most 
architectures.

So what would be needed is for each architecture to define a 'generic 
syscall table base index', ARCH_SYSCALL_BASE or so, and the generic 
syscalls would be added for that.

Alpha would have 501, the others lower numbers.

The only general assumption we can rely on is that there's a range of 
not yet used syscall numbers starting at the end of the current 
syscall table.

Thanks,

	Ingo
