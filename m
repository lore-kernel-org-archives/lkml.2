Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0F3JDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:03:54 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56715 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0F3JDx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 05:03:53 -0400
Message-Id: <4C2B24B30200007800008C07@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 10:04:19 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: <jeremy.fitzhardinge@citrix.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -
	 Xen implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
 <1277885135.1868.72.camel@laptop>
 <4C2B21D20200007800008BDF@vpn.id2.novell.com>
 <1277888180.1868.84.camel@laptop>
In-Reply-To: <1277888180.1868.84.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 10:56, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-06-30 at 09:52 +0100, Jan Beulich wrote:
>> > why is that a rwlock?, those things are useless.
>> 
>> Because potentially each CPU's lock gets acquired for reading during
>> unlock, while only the locking CPU's one needs to be acquired for
>> writing during lock. 
> 
> Can you say: scalability nightmare? but then its Xen code so who cares..

Yes, this is a scalability problem. And yes, I'm open to suggestions.
But no, I didn't have any better idea myself. And for the time being
I don't foresee this to be a problem, as VMs tend to have much fewer
CPUs than physical machines. And I think a performance win of 25%
justifies a sub-optimal implementation (with the perspective of people
smarter than me replacing it with a better one over time).

Jan

