Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab0GBTdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:33:55 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:25000 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0GBTdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:33:53 -0400
Message-ID: <4C2E3F1F.3010202@tilera.com>
Date: Fri, 2 Jul 2010 15:33:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Break out types from <linux/list.h> to	<linux/list_types.h>.
References: <201007021811.04197.arnd@arndb.de> <201007021747.o62HlgmV019405@farm-0002.internal.tilera.com> <20100702191910.GA5842@parisc-linux.org>
In-Reply-To: <20100702191910.GA5842@parisc-linux.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2010 3:19 PM, Matthew Wilcox wrote:
> On Fri, Jul 02, 2010 at 01:41:14PM -0400, Chris Metcalf wrote:
>   
>> This allows a list_head (or hlist_head, etc.) to be used from places
>> that used to be impractical, in particular <asm/processor.h>, which
>> used to cause include file recursion: <linux/list.h> includes
>> <linux/prefetch.h>, which always includes <asm/processor.h> for the
>> prefetch macros, as well as <asm/system.h>, which often includes
>> <asm/processor.h> directly or indirectly.
>>     
> Why a new header file instead of linux/types.h?
>   

I was working from analogy to kvm_types.h, mm_types.h, rwlock_types.h,
spinlock_types.h.  My impression is that linux/types.h is generally for
basic (non-struct) types, with atomic_t/atomic64_t being added as
"almost non-struct types", and of course the historical exception of
"struct ustat", which has been there since the dawn of time (0.97 anyway).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

