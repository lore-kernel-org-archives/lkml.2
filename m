Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab0EaKpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:45:11 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:59710 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0EaKpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:45:09 -0400
Message-ID: <4C03932F.8000303@cesarb.net>
Date: Mon, 31 May 2010 07:45:03 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Make kunmap_atomic() harder to misuse
References: <1275043993-26557-1-git-send-email-cesarb@cesarb.net> <20100529204256.b92b1ff6.akpm@linux-foundation.org> <201005311945.19784.rusty@rustcorp.com.au>
In-Reply-To: <201005311945.19784.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 31-05-2010 07:15, Rusty Russell escreveu:
> On Sun, 30 May 2010 01:12:56 pm Andrew Morton wrote:
>> On Fri, 28 May 2010 07:53:13 -0300 Cesar Eduardo Barros<cesarb@cesarb.net>  wrote:
>>> +/* Prevent people trying to call kunmap_atomic() as if it were kunmap() */
>>> +struct __kunmap_atomic_dummy {};
>>> +#define kunmap_atomic(addr, idx) do { \
>>> +		BUILD_BUG_ON( \
>>> +			__builtin_types_compatible_p(typeof(addr), struct page *)&&  \
>>> +			!__builtin_types_compatible_p(typeof(addr), struct __kunmap_atomic_dummy *)); \
>>> +		kunmap_atomic_notypecheck((addr), (idx)); \
>>> +	} while (0)
>>
>> We have a little __same_type() helper for this.  __must_be_array()
>> should be using it, too.
>
> Yep... but I think BUILD_BUG_ON(__same_type((addr), struct page *)); is
> sufficient; void * is not compatible in my quick tests here.

That is what I get for only reading the manual instead of testing :(

(I only tested the completed patch, not each step along the way.)

I will try it later today and make a new patch if it works as expected.

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
