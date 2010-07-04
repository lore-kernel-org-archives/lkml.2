Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0GDBsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 21:48:05 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:21273 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab0GDBsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 21:48:03 -0400
Message-ID: <4C2FE84E.4010407@tilera.com>
Date: Sat, 3 Jul 2010 21:47:58 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Matthew Wilcox <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] Break out types from <linux/list.h> to <linux/list_types.h>.
References: <201007021811.04197.arnd@arndb.de> <4C2E3F1F.3010202@tilera.com> <20100702204817.GB5842@parisc-linux.org> <201007031100.43158.arnd@arndb.de>
In-Reply-To: <201007031100.43158.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/2010 5:00 AM, Arnd Bergmann wrote:
> On Friday 02 July 2010 22:48:17 Matthew Wilcox wrote:
>   
>> I wouldn't mind seeing kvm_types.h, rwlock_types.h and spinlock_types.h
>> merged into types.h, personally.  They're all pretty fundamental kernel
>> kind of types.  It's a matter of taste, and I'm not particularly fussed
>> one way or the other.
>>
>> mm_types.h is complex and full of mm-specific information, so keeping
>> it separate makes sense to me.
>>
>> I just object to the unnecessary creation of tiny files like this.
>> Which is how we ended up with atomic_t and atomic64_t in there in the
>> first place :-)
>>     
> Ah, I didn't notice you had moved the atomic types in there. I agree that
> the list types are in the same general category and it makes sense
> to treat them the same way.
>
> For rwlock_types.h and spinlock_types.h, I think including them in types.h
> would really cause too much other crap to be pulled in through lockdep
> and other things we might need in there in the future, which would in turn
> cause the same problems with types.h that Chris is trying to avoid
> in the first place by moving stuff out of list.h.
>   

Sounds like we have a consensus on moving the list_head, hlist_head, and
hlist_node types to <linux/types.h>.  I assume everyone is agreed that
initializers, etc., should stay in <linux/list.h>.  I will send out a
revised git patch on Sunday.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

