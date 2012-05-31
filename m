Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2EaKzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:55:14 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:52977 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751518Ab2EaKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:55:12 -0400
Date: Thu, 31 May 2012 20:54:53 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: nicolas.ferre@atmel.com, jamie@jamieiles.com, linux-kernel@vger.kernel.org,
        GPontis@z9.com, stable@vger.kernel.org
Subject: Re: [PATCH] hw_random: atmel-rng: fix race condition leading to
 repeated bits
Message-ID: <20120531105453.GA6266@gondor.apana.org.au>
References: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337937158-9710-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 11:12:38AM +0200, Peter Korsgaard wrote:
> Data valid gets cleared by reading the ISR (status register) and NOT from
> reading ODATA (data register). A new data word can become available between
> checking ISR and reading ODATA, causing us to reuse the same data word next
> time atmel_trng_read() gets called, if that happens before the following
> data word is ready.

Patch applied crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
