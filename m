Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2KRTcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 14:32:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab2KRTcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 14:32:15 -0500
Date: Sun, 18 Nov 2012 20:32:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
	percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari
	ly.fix
Message-ID: <20121118193235.GA9859@redhat.com>
References: <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org> <20121111182744.GA25282@redhat.com> <20121116152219.d4acc6d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116152219.d4acc6d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16, Andrew Morton wrote:
>
> On Sun, 11 Nov 2012 19:27:44 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> >  lib/percpu-rwsem.c |   35 +++++++++++++++++++++++++++++++++--
>
> y'know, this looks like a great pile of useless bloat for single-CPU
> machines.  Maybe add a CONFIG_SMP=n variant which simply calls the
> regular rwsem operations?

Yes, I thought about this and probably I'll send the patch...

But note that the regular down_read() won't be actually faster if
there is no writer, and it doesn't allow to add other features.

I'll try to think, perhaps it would be enough to add a couple of
"ifdef CONFIG_SMP" into this code, say, to avoid __percpu.

Oleg.

