Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab2BWRSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:18:43 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55035 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2BWRSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:18:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.68 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223100205.GD24310@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com> <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com> <20120223100205.GD24310@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 09:18:21 -0800
X-Google-Sender-Auth: 8Kyt3UmIP4SVB6qUx4rl1q8nZ-Y
Message-ID: <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups + docs
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Having to take the address gives us type safety - i.e. it will
> not be possible to accidentally pass in a non-jump-label key and
> get it misinterpreted.

Ingo, stop with the stupid denialism.

NOBODY likes that name. NOBODY. It's wrong. It's stupid. It sounds
like a stronger "unlikely()", and it simply IS NOT.

So rename it already.

The "type safety" argument seems bogus too. As far as I can tell, it
fails miserably if you test a void pointer for being NULL.

Sure, you can fix that by doing crazy things to the interface, but in
the end, nothing changes the fact that "very_unlikely()" as a name
sounds like an emphatic version of "unlikely()".

Rename it. Make it clear from the name that it is about these static
variables. Everything else seems to be named for that "static_key"
thing, so make the testing of it be named that way too, instead of
using a bad generic naming scheme that is just confusing.

                   Linus
