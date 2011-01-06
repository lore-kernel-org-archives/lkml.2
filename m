Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1AFWdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:33:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41198
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532Ab1AFWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:33:01 -0500
Date: Thu, 06 Jan 2011 14:33:33 -0800 (PST)
Message-Id: <20110106.143333.104055073.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: Crypto Update for 2.6.38
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110106223042.GA27080@gondor.apana.org.au>
References: <20110106213932.GA26538@gondor.apana.org.au>
	<AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
	<20110106223042.GA27080@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Fri, 7 Jan 2011 09:30:42 +1100

> On Thu, Jan 06, 2011 at 02:13:17PM -0800, Linus Torvalds wrote:
>> 
>> But I'm still missing the part where you show that there is any actual
>> use case that makes sense, and that actually improves performance.
>> Maybe it's been posted somewhere else, but the thing is, you're asking
>> _me_ to pull, and as a result you need to convince _me_ that this is a
>> good idea. So if it's been posted/discussed extensively elsewhere,
>> please point to those discussions.
> 
> The main use-case is bulk encryption/hashing in user-space.  For
> example, on Sparc Niagara2 you need to use SPU (Stream Processing
> Unit) in order to do crypto at 10Gb/s over the network.  Because
> of the hardware design, it is difficult to make use of the SPU
> directly in user-space, unless you dedicate the SPU to one single
> thread/user.

The N2 SPU is not accessible at all from userspace.

> However, this is something that has been considered and can be
> easily added.  The idea is to first add symmetric key storage
> capability to the existing in-kernel keyring API.  Once that is
> done we can easily add a new setsockopt to the crypto user-interface
> that retrieves the key from the kernel keyring instead of getting
> it directly from user-space.

That indeed would be real interesting.
