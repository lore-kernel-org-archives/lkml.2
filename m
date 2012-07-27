Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2G0Tk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:40:56 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60311 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2G0Tkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:40:55 -0400
Date: Fri, 27 Jul 2012 14:36:54 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        Peter Huewe <peter.huewe@infineon.com>,
        Bryan Freed <bfreed@chromium.org>
Subject: Re: [GIT PULL] New TPM driver, hwrng driver and fixes
Message-ID: <20120727193654.GA11027@linux.vnet.ibm.com>
References: <20120727181436.GA6271@linux.vnet.ibm.com>
 <5012DCF9.7010408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5012DCF9.7010408@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072719-8974-0000-0000-00000B8C2EA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Since you no longer modify *max anywhere in this function, why leave it
> a pointer?  Making it pass by value seems more logical at that point
> (and cleaner).
> 
> The only consumer which can make use of partial result is
> tpm_rng_read(), but that will now return zero unless the buffer is filled.
> 
> My suggestion would be to drop the pointer and instead return a positive
> result (number of bytes) if you read anything and a negative result
> (-errno) on error.

  Sounds good.  I'll make this change.

Kent

> That way, a caller which can only use an exact number of bytes should do:
> 
> 	rv = tpm_get_random(chip, buf, size);
> 	if (rv != size)
> 		/* error! */
> 
> ... and tpm_rng_read() can do something smarter.
> 
> 	-hpa
> 

