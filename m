Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2JCMzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 08:55:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab2JCMzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 08:55:03 -0400
Message-ID: <506C3583.4040506@redhat.com>
Date: Wed, 03 Oct 2012 14:54:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, x86@vger.kernel.org, eranian@google.com,
        jolsa@redhat.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 06/31] perf, kvm: Support the intx/intx_cp modifiers in
 KVM arch perfmon emulation
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org> <1349221731-15665-7-git-send-email-andi@firstfloor.org> <506C131A.1070600@redhat.com> <20121003121132.GG2628@tassilo.jf.intel.com>
In-Reply-To: <20121003121132.GG2628@tassilo.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 02:11 PM, Andi Kleen wrote:
>> > -			eventsel & ARCH_PERFMON_EVENTSEL_INT);
>> > +			eventsel & ARCH_PERFMON_EVENTSEL_INT,
>> > +			!!(eventsel & HSW_INTX),
>> > +			!!(eventsel & HSW_INTX_CHECKPOINTED));
>> >  }
>> >  
>> 
>> Those !! are !necessary, since the formal argument is a bool.
> 
> bool is 1 or 0, x & y with y > 1 is not 1 or 0.
> iirc assigning > 1 to bool is undefined
> 
> So I think they are necessary.

Conversion to bool coerces the value to 0 or 1.

_Bool ret(int x) { return x & 0x10000; }
  20:	81 e7 00 00 01 00    	and    $0x10000,%edi
  26:	0f 95 c0             	setne  %al
  29:	c3                   	retq


-- 
error compiling committee.c: too many arguments to function
