Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0KKUgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:36:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0KKUgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:36:03 -0500
Date: Thu, 11 Nov 2010 21:29:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101111202922.GB16282@redhat.com>
References: <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins> <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net> <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com> <1289489200.11397.21.camel@maggy.simson.net> <AANLkTinbtfuipoene_M0Om_QtycHGL15Q5E8BOmLU-bh@mail.gmail.com> <1289502511.11397.36.camel@maggy.simson.net> <AANLkTi=hKhsU0Nsenq-jezDVNYQ4fCXFBbUy5c7EFk=U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=hKhsU0Nsenq-jezDVNYQ4fCXFBbUy5c7EFk=U@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Linus Torvalds wrote:
>
> Well, it cuts both ways. Maybe your approach is simpler and avoids
> overhead at scheduling time. And "tsk->signal" may not be reliable due
> to races with exit etc, so it may well be that going through the
> signal struct could end up being a source of nasty races. I didn't
> look whether the scheduler already derefenced ->signal for some other
> reason, for example.

Just in case, starting from 2.6.35 tsk->signal is reliable.

Oleg.

