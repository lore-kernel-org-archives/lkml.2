Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936162Ab1KJDv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:51:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936144Ab1KJDta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:49:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:07 2011
Message-Id: <20111109213207.822039378@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Herbert Xu <herbert@gondor.hengli.com.au>,
        Kerin Millar <kerframil@gmail.com>
Subject: [251/264] crypto: cryptd - Use subsys_initcall to prevent races with aesni
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

commit b2bac6acf86d05d8af0499f37d91ecac15722803 upstream.

As cryptd is depeneded on by other algorithms such as aesni-intel,
it needs to be registered before them.  When everything is built
as modules, this occurs naturally.  However, for this to work when
they are built-in, we need to use subsys_initcall in cryptd.

Tested-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 crypto/cryptd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -945,7 +945,7 @@ static void __exit cryptd_exit(void)
 	crypto_unregister_template(&cryptd_tmpl);
 }
 
-module_init(cryptd_init);
+subsys_initcall(cryptd_init);
 module_exit(cryptd_exit);
 
 MODULE_LICENSE("GPL");


