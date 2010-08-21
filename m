Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0HUHQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:16:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab0HUHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:16:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C6F7D2D.6060101@s5r6.in-berlin.de>
Date: Sat, 21 Aug 2010 09:15:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Miloslav Trmac <mitr@redhat.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>, linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/19] Add ioctl() argument and attribute handling utils
References: <1833173750.1044971282356941800.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1833173750.1044971282356941800.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miloslav Trmac wrote:
> ----- "Stefan Richter" <stefanr@s5r6.in-berlin.de> wrote:
>> Miloslav Trmač wrote:
>>> --- /dev/null
>>> +++ b/crypto/userspace/utils.c
>> [...]
>>> +#ifdef CONFIG_COMPAT
>>> +/* max() is too clever for compile-time constants */
>>> +#define CONST_MAX(A, B) ((A) > (B) ? (A) : (B))
>>> +
>>> +#define MAX_SESSION_INPUT_DATA_SIZE					\
>>> +	(CONST_MAX(sizeof(struct ncr_session_input_data),		\
>>> +		   sizeof(struct compat_ncr_session_input_data)))
>>> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE					\
>>> +	(CONST_MAX(sizeof(struct ncr_session_output_buffer),		\
>>> +		   sizeof(struct compat_ncr_session_output_buffer)))
>>> +
>>> +#else /* !CONFIG_COMPAT */
>>> +
>>> +#define MAX_SESSION_INPUT_DATA_SIZE (sizeof(struct ncr_session_input_data))
>>> +#define MAX_SESSION_OUTPUT_BUFFER_SIZE			\
>>> +	(sizeof(struct ncr_session_output_buffer))
>>> +
>>> +#endif /* !CONFIG_COMPAT */
>> 
>> struct compat_xyz cannot be bigger than struct xyz, can it?
>
> Perhaps not, but the code has been written and it's easier to keep it than to
> speculate :)

What's there to speculate? :-)  COMPAT = 32bit user on 64bit kernel.  The
latter has larger long and pointers and possibly different alignment of 64bit
data.

> It also helps document the fact that the data format depends on properties of
> the userspace.

Since it is a new ABI, it can be written to not need COMPAT ifdef'ery nor
compat handlers.
-- 
Stefan Richter
-=====-==-=- =--- =-=-=
http://arcgraph.de/sr/
