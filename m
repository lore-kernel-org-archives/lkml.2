Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3AIO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:57:23 -0500
Received: from mail1.windriver.com ([147.11.146.13]:38431 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3AIO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:57:21 -0500
Message-ID: <50ED8537.3020409@windriver.com>
Date: Wed, 9 Jan 2013 09:56:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [v2.6.34-stable 71/77] crypto: ghash - Avoid null pointer dereference
 if no key is set
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com> <1357688156-25387-72-git-send-email-paul.gortmaker@windriver.com> <20130109025631.GA12832@elliptictech.com>
In-Reply-To: <20130109025631.GA12832@elliptictech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-01-08 09:56 PM, Nick Bowler wrote:
> On 2013-01-08 18:35 -0500, Paul Gortmaker wrote:
>> From: Nick Bowler <nbowler@elliptictech.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit 7ed47b7d142ec99ad6880bbbec51e9f12b3af74c upstream.
>>
>> The ghash_update function passes a pointer to gf128mul_4k_lle which will
>> be NULL if ghash_setkey is not called or if the most recent call to
>> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
>> up by returning an error code in the null case.
>>
>> This is trivially triggered from unprivileged userspace through the
>> AF_ALG interface by simply writing to the socket without setting a key.
> 
> I haven't been following 2.6.34-longterm development, but unless
> you've also backported the AF_ALG userspace interface from 2.6.38,
> this sequence can only be triggered by kernel code.  So while this
> patch shouldn't break anything, it isn't really necessary.

We've not backported any features or interfaces, as doing so is
generally outside of the mandate of what -stable tries to achieve.
So I'll simply drop the patch.

Thanks for the info.
Paul
--

> 
> Cheers,
> 
