Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2KGTRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:17:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2KGTRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:17:16 -0500
Date: Wed, 7 Nov 2012 14:17:01 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] percpu_rw_semaphore: reimplement to not block
 the readers unnecessarily
In-Reply-To: <20121107174731.GA3075@redhat.com>
Message-ID: <Pine.LNX.4.64.1211071403320.9320@file.rdu.redhat.com>
References: <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com>
 <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com>
 <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
 <20121102180606.GA13255@redhat.com> <20121102180629.GB13255@redhat.com>
 <Pine.LNX.4.64.1211071048140.9669@file.rdu.redhat.com> <20121107174731.GA3075@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Nov 2012, Oleg Nesterov wrote:

> On 11/07, Mikulas Patocka wrote:
> >
> > It looks sensible.
> >
> > Here I'm sending an improvement of the patch - I changed it so that there
> > are not two-level nested functions for the fast path and so that both
> > percpu_down_read and percpu_up_read use the same piece of code (to reduce
> > cache footprint).
> 
> IOW, the only change is that you eliminate "static update_fast_ctr()"
> and fold it into down/up_read which takes the additional argument.
> 
> Honestly, personally I do not think this is better, but I won't argue.
> I agree with everything but I guess we need the ack from Paul.

If you look at generated assembly (for x86-64), the footprint of my patch 
is 78 bytes shared for both percpu_down_read and percpu_up_read.

The footprint of your patch is 62 bytes for update_fast_ctr, 46 bytes for 
percpu_down_read and 20 bytes for percpu_up_read.

Mikulas
