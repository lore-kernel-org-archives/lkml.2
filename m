Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab1HKOu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:50:58 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:48429 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab1HKOu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:50:57 -0400
X-AuditID: 1209190c-b7bdeae000000a26-1e-4e43ebfe0b43
Message-ID: <4E43EC49.1040803@mit.edu>
Date: Thu, 11 Aug 2011 10:50:49 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.hengli.com.au>
CC: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto, x86: SSSE3 based SHA1 implementation for
 x86-64
References: <1311529994-7924-1-git-send-email-minipli@googlemail.com> <1311529994-7924-3-git-send-email-minipli@googlemail.com> <20110804064436.GA16247@gondor.apana.org.au>
In-Reply-To: <20110804064436.GA16247@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsUixG6nrvvvtbOfQecXK4s551tYLPZt5LW4
	f+8nk8XlXXPYLI5fYrH4emkamwObx5aVN5k8vr2X9Xg6YTK7x+I9L5k8Pm+SC2CN4rJJSc3J
	LEst0rdL4Mp43/KDpeAqV8W7JZPYGxh3cnQxcnJICJhIvOl+wghhi0lcuLeerYuRi0NIYB+j
	RPPXOcwQzgZGiRfT7jJCOG+ZJK5efwRUxsHBK6Am8XK5Jkg3i4CqxPn7O5hBbDYBFYmOpQ+Y
	QGxRgSCJ+78bWEBsXgFBiZMzn4DZIgK6EidmnQJbwCxwh1HixLR/YM3CAqES79rOQy1bwyjR
	9HY5K8gyTgFLiS07rEFMZgFriW+7i0DKmQXkJba/ncM8gVFwFpIVsxCqZiGpWsDIvIpRNiW3
	Sjc3MTOnODVZtzg5MS8vtUjXUC83s0QvNaV0EyMo+DkleXYwvjmodIhRgINRiYeXcbWTnxBr
	YllxZe4hRkkOJiVR3nRg7AjxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4X33ECjHm5JYWZValA+T
	kuZgURLnPbjDwU9IID2xJDU7NbUgtQgmK8PBoSTBuwFkqGBRanpqRVpmTglCmomDE2Q4D9Dw
	aJAa3uKCxNzizHSI/ClGRSlx3mUgCQGQREZpHlwvLDm9YhQHekWYdyFIFQ8wscF1vwIazAQ0
	uP6OA8jgkkSElFQDI8+u/EV7f3baJSy81JmW3FYwSWXxPL9tkoIL02sDzqy78GpLzwO2Rl22
	+euj/FU3llUvXG7WtGrffL3IG6e2vD8pe5VVqoR/x5c75W3cbG9F5ol6MX4uKvq5qSU87pzQ
	vt8chv11jXZ3qzP5lXK/OaacOjJxiva8q4IH8+I/amZ77Nty9Vd5oBJLcUaioRZzUXEiAB7C
	JJcpAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 02:44 AM, Herbert Xu wrote:
> On Sun, Jul 24, 2011 at 07:53:14PM +0200, Mathias Krause wrote:
>>
>> With this algorithm I was able to increase the throughput of a single
>> IPsec link from 344 Mbit/s to 464 Mbit/s on a Core 2 Quad CPU using
>> the SSSE3 variant -- a speedup of +34.8%.
>
> Were you testing this on the transmit side or the receive side?
>
> As the IPsec receive code path usually runs in a softirq context,
> does this code have any effect there at all?
>
> This is pretty similar to the situation with the Intel AES code.
> Over there they solved it by using the asynchronous interface and
> deferring the processing to a work queue.

I have vague plans to clean up extended state handling and make 
kernel_fpu_begin work efficiently from any context.  (i.e. the first 
kernel_fpu_begin after a context switch could take up to ~60 ns on Sandy 
Bridge, but further calls to kernel_fpu_begin would be a single branch.)

The current code that handles context switches when user code is using 
extended state is terrible and will almost certainly become faster in 
the near future.

Hopefully I'll have patches for 3.2 or 3.3.

IOW, please don't introduce another thing like the fpu crypto module 
quite yet unless there's a good reason.  I'm looking forward to deleting 
the fpu module entirely.

--Andy
