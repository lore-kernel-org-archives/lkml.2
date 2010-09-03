Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0ICJiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:38:08 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56473 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751250Ab0ICJiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:38:06 -0400
Date: Fri, 3 Sep 2010 05:38:00 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <245859135.862181283506680927.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <423332662.861981283506383923.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH 01/19] User-space API definition
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Herbert Xu" <herbert@gondor.hengli.com.au> wrote:
> Thanks for the updated patch-set.  It does indeed fulfil some
> of the requirements raised earlier.
> 
> However, as far as I can see this still does not address the
> extensibility.  For example, say we want add an interface to
> allow the xoring of two arbitrary data streams using DMA offload,
> this interface would make that quite awkward.
I don't think this would be a problem:

- Expose the xoring as a crypto_tfm, with the usual crypto API string identifier
  (this is supposed to be a crypto API interface, not a generic interface
  to the platform DMA controller, after all).

- Check to see if the operation can be supported using the existing
  attributes, add attributes if necessary.

  In this case, NCR_UPDATE_INPUT_DATA can be used for the read-only
  stream and NCR_UPDATE_OUTPUT_BUFFER for the read-write steram.

- If this is an entirely new crypto transform type, add support to
  the session interface.

  In this case, this would probably mean adding NCR_OP_COMBINE (or
  something similar); SESSION_INIT would only allocate the tfm,
  SESSION_UPDATE would be used for handling blocks of data as they
  come and go.

The interface would have to be extended, but the extension would be completely backward-compatible and the additions to the interface would probably be smaller than the additions to the internal crypto API.  Notably no new ioctl()s would be needed.
    Mirek
