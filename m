Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0KKTiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:38:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676Ab0KKTh7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:37:59 -0500
MIME-Version: 1.0
In-Reply-To: <1289502511.11397.36.camel@maggy.simson.net>
References: <1287479765.9920.9.camel@marge.simson.net> <1287487757.24189.40.camel@marge.simson.net>
 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
 <1287511983.7417.45.camel@marge.simson.net> <1287514410.7368.10.camel@marge.simson.net>
 <20101020025652.GB26822@elte.hu> <1287648715.9021.20.camel@marge.simson.net>
 <20101021105114.GA10216@Krystal> <1287660312.3488.103.camel@twins>
 <20101021162924.GA3225@redhat.com> <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net> <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net> <AANLkTinbtfuipoene_M0Om_QtycHGL15Q5E8BOmLU-bh@mail.gmail.com>
 <1289502511.11397.36.camel@maggy.simson.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Nov 2010 11:37:28 -0800
Message-ID: <AANLkTi=hKhsU0Nsenq-jezDVNYQ4fCXFBbUy5c7EFk=U@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 11:08 AM, Mike Galbraith <efault@gmx.de> wrote:
>
>>  - the reason I suggested the signal struct was really that I thought
>> it would avoid extra (unnecessary) cost in thread creation/teardown.
>>
>>    Maybe I should have made that clear, but this seems to
>> unnecessarily do the whole atomic_inc/dec for each thread. That seems
>> a bit sad.
>>
>>    That said, if not having to dereference ->signal simplifies the
>> scheduler interaction, I guess the extra atomic ref at thread
>> creation/deletion is fine. So I don't think this is wrong, it's just
>> something I wanted to bring up.
>
> Ah, ok.  Anything that cuts overhead is worth doing.

Well, it cuts both ways. Maybe your approach is simpler and avoids
overhead at scheduling time. And "tsk->signal" may not be reliable due
to races with exit etc, so it may well be that going through the
signal struct could end up being a source of nasty races. I didn't
look whether the scheduler already derefenced ->signal for some other
reason, for example.

So your patch may well have done the exact right thing.

                              Linus
