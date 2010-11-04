Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0KDTXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 15:23:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45566
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab0KDTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 15:23:18 -0400
Date: Thu, 04 Nov 2010 12:23:42 -0700 (PDT)
Message-Id: <20101104.122342.39162219.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
 skcipher operations
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1PE3jY-0000Ml-7B@gondolin.me.apana.org.au>
References: <20101104173456.GA1321@gondor.apana.org.au>
	<E1PE3jY-0000Ml-7B@gondolin.me.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 04 Nov 2010 12:36:20 -0500

> crypto: algif_skcipher - User-space interface for skcipher operations
> 
> This patch adds the af_alg plugin for symmetric key ciphers,
> corresponding to the ablkcipher kernel operation type.
> 
> Keys can optionally be set through the setsockopt interface.
> 
> Once a sendmsg call occurs without MSG_MORE no further writes
> may be made to the socket until all previous data has been read.
> 
> IVs and and whether encryption/decryption is performed can be
> set through the setsockopt interface or as a control message
> to sendmsg.
> 
> The interface is completely synchronous, all operations are
> carried out in recvmsg(2) and will complete prior to the system
> call returning.
> 
> The splice(2) interface support reading the user-space data directly
> without copying (except that the Crypto API itself may copy the data
> if alignment is off).
> 
> The recvmsg(2) interface supports directly writing to user-space
> without additional copying, i.e., the kernel crypto interface will
> receive the user-space address as its output SG list.
> 
> Thakns to Miloslav Trmac for reviewing this and contributing
> fixes and improvements.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
