Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0D0Oqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:46:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:28320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab0D0Oqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:46:51 -0400
Message-ID: <4BD6F81B.1010606@vflare.org>
Date: Tue, 27 Apr 2010 20:13:39 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default> <20100427125502.GA3681@ucw.cz>
In-Reply-To: <20100427125502.GA3681@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 06:25 PM, Pavel Machek wrote:
> 
>>> Can we extend it?  Adding new APIs is easy, but harder to maintain in
>>> the long term.
>>
>> Umm... I think the difference between a "new" API and extending
>> an existing one here is a choice of semantics.  As designed, frontswap
>> is an extremely simple, only-very-slightly-intrusive set of hooks that
>> allows swap pages to, under some conditions, go to pseudo-RAM instead
> ...
>> "Extending" the existing swap API, which has largely been untouched for
>> many years, seems like a significantly more complex and error-prone
>> undertaking that will affect nearly all Linux users with a likely long
>> bug tail.  And, by the way, there is no existence proof that it
>> will be useful.
> 
>> Seems like a no-brainer to me.
> 
> Stop right here. Instead of improving existing swap api, you just
> create one because it is less work.
> 
> We do not want apis to cummulate; please just fix the existing one.


I'm a bit confused: What do you mean by 'existing swap API'?
Frontswap simply hooks in swap_readpage() and swap_writepage() to
call frontswap_{get,put}_page() respectively. Now to avoid a hardcoded
implementation of these function, it introduces struct frontswap_ops
so that custom implementations fronswap get/put/etc. functions can be
provided. This allows easy implementation of swap-to-hypervisor,
in-memory-compressed-swapping etc. with common set of hooks.

So, how frontswap approach can be seen as introducing a new API?

Thanks,
Nitin






