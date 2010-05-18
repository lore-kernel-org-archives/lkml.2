Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0ERTZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:25:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54669
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757791Ab0ERTZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:25:06 -0400
Date: Tue, 18 May 2010 12:25:12 -0700 (PDT)
Message-Id: <20100518.122512.73694279.davem@davemloft.net>
To: herbert@gondor.hengli.com.au
Cc: ken@codelabs.ch, mpm@selenic.com, geert@linux-m68k.org,
       michael-dev@fami-braun.de, penberg@cs.helsinki.fi,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Subject: Re: [BUG] SLOB breaks Crypto
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100518102701.GA7293@gondor.apana.org.au>
References: <1274135869.11603.473.camel@calx>
	<4BF24D1F.6010005@codelabs.ch>
	<20100518102701.GA7293@gondor.apana.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Tue, 18 May 2010 20:27:01 +1000

> I think the simplest fix is to revert this changeset.

If you revert then you'll break sparc.

Sparc needs long long alignment, so it's SLOB that needs to
change if it isn't providing at least that much alignment
by default.
