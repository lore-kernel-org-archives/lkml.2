Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1J1BfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 21:35:12 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48405 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1J1BfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 21:35:10 -0400
MIME-Version: 1.0
In-Reply-To: <20111028012521.GF25795@one.firstfloor.org>
References: <1319764761.23112.14.camel@edumazet-laptop> <20111028012521.GF25795@one.firstfloor.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 27 Oct 2011 18:34:48 -0700
X-Google-Sender-Auth: 4T7NUehy3AGttKhUrdZqiEfYpbQ
Message-ID: <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
Subject: Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
To: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 6:25 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Seems reasonable too. In fact we usually should have memory barriers
> for this anyways which obsolete the volatile.

No we shouldn't. Memory barriers are insanely expensive, and pointless
for atomics - that aren't ordered anyway.

You may mean compiler barriers.

That said, removing the volatile entirely might be a good idea, and
never mind any barriers at all. The ordering for atomics really isn't
well enough specified that we should care. So I wouldn't object to a
patch that just removes the volatile entirely, but it would have to be
accompanied with quite a bit of testing, in case some odd case ends up
depending on it. But nothing *should* be looping on those things
anyway.

                       Linus
