Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab2GJXSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:18:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53687 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2GJXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:18:40 -0400
MIME-Version: 1.0
In-Reply-To: <op.wg8cv6x53l0zgt@mpn-glaptop>
References: <1341876923-12469-1-git-send-email-walken@google.com>
	<1341876923-12469-6-git-send-email-walken@google.com>
	<op.wg8cv6x53l0zgt@mpn-glaptop>
Date: Tue, 10 Jul 2012 16:18:39 -0700
Message-ID: <CANN689EfR=aSiwq+7GY1nh4-CkoPSPVx=xycoRAjLPTHAcm5_A@mail.gmail.com>
Subject: Re: [PATCH 05/13] rbtree: performance and correctness test
From: Michel Lespinasse <walken@google.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, axboe@kernel.dk,
        ebiederm@xmission.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 5:27 AM, Michal Nazarewicz <mina86@mina86.com> wrote:
> On Tue, 10 Jul 2012 01:35:15 +0200, Michel Lespinasse <walken@google.com> wrote:
>> +       for (i = 0; i < CHECK_LOOPS; i++) {
>> +               init();
>
> Is this init() needed?

So, the reasoning here is that we first have timed loops, where we
don't init between every iteration because it's not needed. Then we
have checked loops, where we init nodes between every iteration so
that they'll have new contents, and then check the rbtree invariants
after each insertion or erase. The init isn't required in the checked
loop either, but it should improve the test coverage a little. It'd be
pointless to run the checked loop more than once if we didn't init...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
