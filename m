Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0KMNAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 08:00:08 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33247 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0KMNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 08:00:07 -0500
Date: Sat, 13 Nov 2010 20:59:59 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Crypto Fixes for 2.6.37
Message-ID: <20101113125959.GA19115@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20090613020512.GA21024@gondor.apana.org.au> <20090910141905.GA17948@gondor.apana.org.au> <20091020065442.GA5947@gondor.apana.org.au> <20091230021253.GA17067@gondor.apana.org.au> <20100201195204.GA6953@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201195204.GA6953@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This push fixes a couple of bugs in hardware crypto support:

* VIA Padlock had a serious problem dealing with odd-block-sized
  input for AES-CBC which causes memory overwrites beyond the
  end of the output buffer.  Luckily the main user which is IPsec
  has plenty of padding that avoids any serious consequences.
* Null check on the wrong variable in Sparc n2.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Herbert Xu (1):
      crypto: padlock - Fix AES-CBC handling on odd-block-sized input

Nicolas Kaiser (1):
      crypto: n2 - dubious error check

 drivers/crypto/n2_core.c     |    2 +-
 drivers/crypto/padlock-aes.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 
Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
