Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934688Ab0KQJer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 04:34:47 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:33347 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588Ab0KQJep convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:12:1>);
	Wed, 17 Nov 2010 04:34:45 -0500
Message-Id: <4CE3AFC00200007800022B85@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 17 Nov 2010 09:34:40 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        "Eric Dumazet" <dada1@cosmosbay.com>, <xiyou.wangcong@gmail.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
        "Linux Virtualization" <virtualization@lists.linux-foundation.org>,
        "Xen-devel" <xen-devel@lists.xensource.com>,
        "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
        "Avi Kivity" <avi@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 13/14] x86/ticketlock: add slowpath logic
References: <cover.1289940821.git.jeremy.fitzhardinge@citrix.com><cover.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <97ed99ae9160bdb6477284b333bd6708fb7a19cb.1289940821.git.jeremy.fitzhardinge@citrix.com>
 <4CE3A1060200007800022B04@vpn.id2.novell.com> <4CE397C8.9040901@goop.org>
 <4CE398A0.3040105@goop.org> <4CE39B7A.1080706@goop.org>
In-Reply-To: <4CE39B7A.1080706@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.11.10 at 10:08, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On 11/17/2010 12:56 AM, Jeremy Fitzhardinge wrote:
>> On 11/17/2010 12:52 AM, Jeremy Fitzhardinge wrote:
>>> But, yes, %z0 sounds interesting.  Is it documented anywhere?  I think
>>> I've tried to use it in the past and run into gcc bugs.
>> This one: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=39590 
>>
>> Should be OK in this case because there's no 64-bit values to be seen...
> Hm, it fails when __ticket_t is 16 bits:
> 
> /home/jeremy/git/linux/arch/x86/include/asm/spinlock.h: Assembler messages:
> /home/jeremy/git/linux/arch/x86/include/asm/spinlock.h:73: Error: suffix
> or operands invalid for `or'
> 
>         lock; ors $1, 2(%rbx)   #,
> 
> 
> So I don't think that's going to work out...

Indeed, it's only with 4.5 that non-float operands are properly
supported here. Sad.

Jan

