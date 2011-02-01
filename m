Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab1BAGUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:20:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:53267 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab1BAGUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:20:36 -0500
Subject: Re: call_function_many: fix list delete vs add race
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Milton Miller <miltonm@bga.com>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikZXh4NbwTCj22dTAEjnNjtEdGtQpTDChw=fckN@mail.gmail.com>
References: <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296508677.26581.84.camel@laptop> <1296519764.2349.325.camel@pasglop>
	 <AANLkTikEo4Bbqn27nCO_xjwEuy9rkoqBjoOb_HeGw18D@mail.gmail.com>
	 <20110201021831.GB2158@linux.vnet.ibm.com>
	 <AANLkTimb7bpTa0fO2VU4pSxO-a3-eQNA6zA_ikAReXsQ@mail.gmail.com>
	 <20110201044517.GC2158@linux.vnet.ibm.com>
	 <AANLkTikZXh4NbwTCj22dTAEjnNjtEdGtQpTDChw=fckN@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 17:18:03 +1100
Message-ID: <1296541083.2349.337.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-01 at 15:46 +1000, Linus Torvalds wrote:
> 
> Quite frankly, the POWER case is made worse by the fact that the
> synchronization primitives have this total confusion about "pipeline"
> synchronization due to historical implementation oddities etc. Talk
> about crazy. The whole "isync" vs "sync" vs "lwsync" thing is just an
> embarrassment. But this is, after all, a company that ran out of
> vowels in instruction naming, so I guess their misleading and confused
> naming for memory ordering is just par for the course.

You forgot eieio, that's where all the vowels go !

Cheers,
Ben.

