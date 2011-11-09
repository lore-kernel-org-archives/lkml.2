Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1KID1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 22:27:39 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51453 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KID1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 22:27:37 -0500
Date: Wed, 9 Nov 2011 11:27:30 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Daniil Stolnikov <danila.st@mail.ru>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        adobriyan@gmail.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: Add IPSec IP Range in Linux kernel
Message-ID: <20111109032729.GA11312@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <552673196.20111109103207@mail.ru>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apa
	na.lists.os.linux.netdev
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniil Stolnikov <danila.st@mail.ru> wrote:
>> Like I said, if you want address ranges, ask the userland IPSEC daemon
>> authors to synthesize it.
> 
> In this letter, the mailing list http://marc.info/?l=strongswan-users&m=130613736616488&w=4 strongswan-users say that their product has support for IP ranges, but the stack of Linux is based on network masks. So I do not understand how this would work without the support at the kernel level? How will coordination of policies?

Simple, you break a range policy into parts that can be expressed
as network/mask and install multiple policies.  The actual policies
in the kernel just has to have the same effect as the one you
negotiated with the other side, it does not have to look the same.

This is also why you can do the same thing with masks + netfilter.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
