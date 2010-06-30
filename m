Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0F3Ivh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:51:37 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41901 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab0F3Ivg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 04:51:36 -0400
Message-Id: <4C2B21D20200007800008BDF@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 09:52:02 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <jeremy.fitzhardinge@citrix.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -
	 Xen implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
 <1277885135.1868.72.camel@laptop>
In-Reply-To: <1277885135.1868.72.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 10:05, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-06-29 at 15:32 +0100, Jan Beulich wrote:
>> +static DEFINE_PER_CPU(arch_rwlock_t, spinning_rm_lock) = 
> __ARCH_RW_LOCK_UNLOCKED;
> 
> why is that an arch_ lock?

Because I don't think it is appropriate to use anything higher level
in the callouts from the lock/unlock inline functions. The alternative
would be an open coded lock, which seems much less desirable to
me.

> why is that a rwlock?, those things are useless.

Because potentially each CPU's lock gets acquired for reading during
unlock, while only the locking CPU's one needs to be acquired for
writing during lock.

Jan

