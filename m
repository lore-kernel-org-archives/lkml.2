Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1ERVAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:00:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39031 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1ERVAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:00:09 -0400
Date: Wed, 18 May 2011 22:59:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, jolsa@redhat.com, stable@kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, 64-bit: Fix copy_[to/from]_user() checks
 for the userspace address limit
Message-ID: <20110518205952.GA25923@elte.hu>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com>
 <tip-26afb7c661080ae3f1f13ddf7f0c58c4f931c22b@git.kernel.org>
 <BANLkTimoHTmSa4LwpN-FLiEwWVLfBetV8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimoHTmSa4LwpN-FLiEwWVLfBetV8g@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, May 18, 2011 at 1:43 PM, tip-bot for Jiri Olsa <jolsa@redhat.com> wrote:
> > As reported in BZ #30352:
> >
> >  https://bugzilla.kernel.org/show_bug.cgi?id=30352
> >
> > there's a kernel bug related to reading the last allowed page on x86_64.
> 
> Btw, I think this message is very misleading.
> 
> It has nothing what-so-ever to do with "the last allowed page".

Yeah, i noticed that and this is why i added this bit from Brian's explanation 
to the end of the commit:

    The bug is that the last byte before the guard page can't be read
    because of the off-by-one error. The guard page is left in place.

I should have fixed the original changelog instead of trying to clarify it via 
appending it ...

Thanks,

	Ingo
