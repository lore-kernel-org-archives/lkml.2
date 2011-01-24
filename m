Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab1AXU2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:28:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab1AXU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:28:18 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
References: <20110124133400.GA1228@elte.hu> <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
 <20110124200738.GA10833@elte.hu> <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Jan 2011 06:27:31 +1000
Message-ID: <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 6:17 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It only happens for me with "g". With "perf record -af sleep 10" it worked.

Actually, it's something subtler than that. It must depend on the
actual data, because now when I tried it again, it worked with 'g'
too. I hadn't saved the old perf.data that caused the lockup (it got
overwritten by the non-g test), and now when I try to re-create it it
doesn't hang on the result.

So it's probably some very specific data pattern that causes it.

(And I don't know if it's a hard hang - it could just be something
_very_ slow. But we're talking half a minute kind of slow).

                     Linus
