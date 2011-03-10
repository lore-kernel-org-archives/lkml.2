Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1CJIJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:09:17 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:44422 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1CJIJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:09:13 -0500
Subject: Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
	top level
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: James.Bottomley@hansenpartnership.com, hch@infradead.org,
        rdunlap@xenotime.net, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20110308093334.GA21996@gondor.apana.org.au>
References: <20110308093334.GA21996@gondor.apana.org.au>
Content-Type: text/plain
Date: Thu, 10 Mar 2011 00:02:21 -0800
Message-Id: <1299744141.5263.25.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-08 at 17:33 +0800, Herbert Xu wrote:
> Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> >
> >> > I should mention this is with the following .config:
> >> > 
> >> > CONFIG_CRYPTO_CRC32C=y
> >> > CONFIG_CRYPTO_CRC32C_INTEL=m
> 
> This is why you get the unoptimised version.  Had you selected
> both as built-in or both as modules, then it would have worked
> as intended.
>  

<nod>

> > What about the following to simply call request_module("crc32c_intel")
> > at module_init() time and top the extra iscsi_login_setup_crypto()
> > code..?
> 
> If we're going to do this we should do it in the crypto layer,
> and not litter every single crypto API user with such crap.
> 
> Currently we don't invoke request_module unless no implementation
> is reigstered for an algorithm.  You can change this so that it
> also invokes request_module if we have not yet done so at least
> once for that algorithm.
> 
> Patches are welcome.
> 

Ok, fair enough point..  I have addressed this with a new struct
crypto_alg->cra_check_optimized() callback in order for crc32c.ko to
have a method to call request_module("crc32c_intel.ko") after the base
software alg has been loaded.

This is working w/ CONFIG_CRYPTO_CRC32C=y + CONFIG_CRYPTO_CRC32C_INTEL=m
case and should satisfy current (and future) architecture dependent
cases for CRC32C HW offload.

Sending out a patch series for your comments shortly..

Thanks!

--nab

