Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab1JNROB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:14:01 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:50950 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933334Ab1JNRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:13:59 -0400
X-Greylist: delayed 9346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 13:13:59 EDT
Date: Fri, 14 Oct 2011 13:13:58 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ghash: Avoid null pointer dereference if no key
 is set.
Message-ID: <20111014171358.GA15626@elliptictech.com>
References: <1318603040-1360-1-git-send-email-nbowler@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318603040-1360-1-git-send-email-nbowler@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-14 10:37 -0400, Nick Bowler wrote:
> The ghash_update function passes a pointer to gf128mul_4k_lle which will
> be NULL if ghash_setkey is not called or if the most recent call to
> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
> up by returning an error code in the null case.
> 
> This is trivially triggered from unpriviliged userspace through the
> AF_ALG interface by simply writing to the socket without setting a key.

It looks like this can also happen in ghash_final if an evil user calls
setkey, update with a length that's not a multiple of the block size,
then setkey again (this time failing due to an allocation failure) then
final.  Thus, I suppose that final needs the same check.

v2 forthcoming...
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
