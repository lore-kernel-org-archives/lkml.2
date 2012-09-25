Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab2IYRbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 13:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab2IYRbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 13:31:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1348588977.22489.55.camel@vespa.frost.loc>
References: <1348588977.22489.55.camel@vespa.frost.loc> <20120925163037.20ba3f3c@pyramind.ukuu.org.uk> <5555.1348531649@warthog.procyon.org.uk> <21845.1348585794@warthog.procyon.org.uk> <30071.1348587320@warthog.procyon.org.uk>
To: Tomas Mraz <tmraz@redhat.com>
Cc: dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        rusty@rustcorp.com.au, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 18:31:25 +0100
Message-ID: <12475.1348594285@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Mraz <tmraz@redhat.com> wrote:

> You can use openssl ca that allows to set arbitrary start date to
> generate selfsigned certs as well (-selfsign option).

That seems to require some stuff I don't have installed:

warthog>openssl ca -in signing_key.priv -extensions v3_ca -out newcert.pem
Using configuration from /etc/pki/tls/openssl.cnf
Error opening CA private key /etc/pki/CA/private/cakey.pem
140244246955872:error:0200100D:system library:fopen:Permission denied:bss_file.c:398:fopen('/etc/pki/CA/private/cakey.pem','r')
140244246955872:error:20074002:BIO routines:FILE_CTRL:system lib:bss_file.c:400:
unable to load CA private key
unable to write 'random state'

(the /etc/pki/CA/private/ dir is inaccessible if not root and doesn't in any
case contain cakey.pem).

Do I need to start with all the CA stuff in the right places to use it?

David
