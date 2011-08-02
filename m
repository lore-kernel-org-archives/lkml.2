Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1HBAC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 20:02:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668Ab1HBACu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 20:02:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110801190341.GA6898@albatros>
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Aug 2011 14:01:38 -1000
Message-ID: <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: initcall dependency problem (ns vs. threads)
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        kernel-hardening@lists.openwall.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Marc Zyngier <maz@misterjones.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 1, 2011 at 9:03 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> Are we talking about init_ipc_ns.ids[] here?  If so, did you try
>> initializing the three rwsems at compile-time?
>>
>> That's rather a nasty hack though.  It'd be better to run the mystery
>> init function before starting the threads.
>
> Looks like it solves the race.  However, I think it should be solved on
> another level.  Other bugs might be hidden with this race.

Statically initializing code data structures in order to avoid these
kinds of problems is the correct fix.

Can you send me the patch?

              Linus
