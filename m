Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab0EFKuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab0EFKuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:50:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100506123049.082e98cc.sfr@canb.auug.org.au>
References: <20100506123049.082e98cc.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dhowells@redhat.com, James Morris <jmorris@namei.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: linux-next: manual merge of the security-testing tree with Linus' tree
Date: Thu, 06 May 2010 11:49:48 +0100
Message-ID: <7197.1273142988@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I just used the version from Linus' tree.

Okay.

However, I'd like to NAK some bits of c5b60b5e67af8be4c58d3ffcc36894f69c4fbdc1
now that I see it...

	@@ -1282,16 +1282,16 @@ long keyctl_session_to_parent(void)
	 
	        /* the parent must have the same effective ownership and mustn't be
	         * SUID/SGID */
	-       if (pcred-> uid != mycred->euid ||
	+       if (pcred->uid  != mycred->euid ||
	            pcred->euid != mycred->euid ||
	            pcred->suid != mycred->euid ||
	-           pcred-> gid != mycred->egid ||
	+           pcred->gid  != mycred->egid ||
	            pcred->egid != mycred->egid ||
	            pcred->sgid != mycred->egid)
	                goto not_permitted;
	 
	        /* the keyrings must have the same UID */
	-       if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
	+       if (pcred->tgcred->session_keyring->uid != mycred->euid ||
	            mycred->tgcred->session_keyring->uid != mycred->euid)
	                goto not_permitted;

_Please_ don't do either of these.  The whole point is to line stuff up so
that as the eye scans down the lines, it can easily pick out the differences
in stuff that's otherwise greatly repetitive.

David
