Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509Ab0GBVJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 17:09:49 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:7198 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab0GBVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 17:09:47 -0400
Message-ID: <4C2E5598.2090503@tilera.com>
Date: Fri, 2 Jul 2010 17:09:44 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Break out types from <linux/list.h> to	<linux/list_types.h>.
References: <201007021811.04197.arnd@arndb.de> <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com> <20100702191910.GA5842@parisc-linux.org> <4C2E3F1F.3010202@tilera.com> <20100702204817.GB5842@parisc-linux.org>
In-Reply-To: <20100702204817.GB5842@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2010 4:48 PM, Matthew Wilcox wrote:
> On Fri, Jul 02, 2010 at 03:33:52PM -0400, Chris Metcalf wrote:
>   
>> On 7/2/2010 3:19 PM, Matthew Wilcox wrote:
>>     
>>> Why a new header file instead of linux/types.h?
>>>       
>> I was working from analogy to kvm_types.h, mm_types.h, rwlock_types.h,
>> spinlock_types.h.  My impression is that linux/types.h is generally for
>> basic (non-struct) types, with atomic_t/atomic64_t being added as
>> "almost non-struct types", and of course the historical exception of
>> "struct ustat", which has been there since the dawn of time (0.97 anyway).
>>     
> I think list_head, hlist_head and hlist_node qualify as "almost non-struct
> types", don't you?  :-)
>   

I see the smiley, but to reply seriously, the distinction I was making
was that atomic_t is really just an integer type, but with typing magic
to protect it from implicit conversion -- unlike list_head, which really
is a more complex type.

I suppose one could make a kind of "intent of the founders"
constitutional law-type argument suggesting that the presence of "struct
ustat" suggests more complex types are in fact appropriate in
<linux/types.h>.  :-)

> I wouldn't mind seeing kvm_types.h, rwlock_types.h and spinlock_types.h
> merged into types.h, personally.  They're all pretty fundamental kernel
> kind of types.  It's a matter of taste, and I'm not particularly fussed
> one way or the other.
>   

Somehow it's hard to see kvm_ioapic_redirect_entry on a par with size_t :-)

> I just object to the unnecessary creation of tiny files like this.
> Which is how we ended up with atomic_t and atomic64_t in there in the
> first place :-)
>   

In any case, I think this either way is plausible, but in the absence of
more folks weighing in, I think "avoid adding a complex type to
<linux/types.h>" sounds more convincing to me than "avoid adding a new
tiny file", though I certainly do buy the latter argument.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

