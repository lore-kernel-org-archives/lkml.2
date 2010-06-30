Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab0F3LZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:25:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50166 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab0F3LZB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Wed, 30 Jun 2010 07:25:01 -0400
Message-Id: <4C2B45C60200007800008CA6@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Jun 2010 12:25:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "Peter Zijlstra" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Ky Srinivasan" <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 4/4, v2] x86: enlightenment for ticket spin locks -
	 improve yield behavior on Xen
References: <4C2A20E30200007800008A17@vpn.id2.novell.com>
 <1277885485.1868.74.camel@laptop>
 <4C2B21300200007800008BDC@vpn.id2.novell.com> <4C2B180E.9060104@goop.org>
In-Reply-To: <4C2B180E.9060104@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 30.06.10 at 12:10, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 06/30/2010 10:49 AM, Jan Beulich wrote:
>>>>> On 30.06.10 at 10:11, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>         
>>> On Tue, 2010-06-29 at 15:35 +0100, Jan Beulich wrote:
>>>     
>>>> The (only) additional overhead this introduces for native execution is
>>>> the writing of the owning CPU in the lock acquire paths. 
>>>>       
>>> Uhm, and growing the size of spinlock_t to 6 (or 8 bytes when aligned)
>>> bytes when NR_CPUS>256.
>>>     
>> Indeed, I should have mentioned that. Will do so in an eventual
>> next version.
>>   
> 
> Rather than increasing the lock size, why not just disable the
> enlightenment if the number of (possible) cpus is > 256?  I don't think
> a VM will ever have that many cpus, so it will only apply in the case of
> booting the kernel on large physical machine.

While that would be an option, I think the decision to go either
way should really be left to the user (after all that's why there
is a config option in the first place).

Jan

