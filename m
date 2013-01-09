Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3AIC4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:56:35 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:59770 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3AIC4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:56:34 -0500
Date: Tue, 8 Jan 2013 21:56:31 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [v2.6.34-stable 71/77] crypto: ghash - Avoid null pointer
 dereference if no key is set
Message-ID: <20130109025631.GA12832@elliptictech.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
 <1357688156-25387-72-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357688156-25387-72-git-send-email-paul.gortmaker@windriver.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-08 18:35 -0500, Paul Gortmaker wrote:
> From: Nick Bowler <nbowler@elliptictech.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 7ed47b7d142ec99ad6880bbbec51e9f12b3af74c upstream.
> 
> The ghash_update function passes a pointer to gf128mul_4k_lle which will
> be NULL if ghash_setkey is not called or if the most recent call to
> ghash_setkey failed to allocate memory.  This causes an oops.  Fix this
> up by returning an error code in the null case.
> 
> This is trivially triggered from unprivileged userspace through the
> AF_ALG interface by simply writing to the socket without setting a key.

I haven't been following 2.6.34-longterm development, but unless
you've also backported the AF_ALG userspace interface from 2.6.38,
this sequence can only be triggered by kernel code.  So while this
patch shouldn't break anything, it isn't really necessary.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
