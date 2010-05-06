Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0EFXKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:10:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:49360 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0EFXKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:10:54 -0400
Date: Fri, 7 May 2010 09:10:32 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: linux-next: manual merge of the security-testing tree with Linus'
 tree
In-Reply-To: <7197.1273142988@redhat.com>
Message-ID: <alpine.LRH.2.00.1005070908230.31779@tundra.namei.org>
References: <20100506123049.082e98cc.sfr@canb.auug.org.au> <7197.1273142988@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, David Howells wrote:

> 
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I just used the version from Linus' tree.
> 
> Okay.
> 
> However, I'd like to NAK some bits of c5b60b5e67af8be4c58d3ffcc36894f69c4fbdc1
> now that I see it...

Will a patch -R of below be correct enough for you?  Otherwise, please 
send me a new patch.

(This is one of the reasons why I'm not so keen on whitespace fixes, also 
having to resolve merge conflicts, peturbing the history of the code etc.)


> 
> 	@@ -1282,16 +1282,16 @@ long keyctl_session_to_parent(void)
> 	 
> 	        /* the parent must have the same effective ownership and mustn't be
> 	         * SUID/SGID */
> 	-       if (pcred-> uid != mycred->euid ||
> 	+       if (pcred->uid  != mycred->euid ||
> 	            pcred->euid != mycred->euid ||
> 	            pcred->suid != mycred->euid ||
> 	-           pcred-> gid != mycred->egid ||
> 	+           pcred->gid  != mycred->egid ||
> 	            pcred->egid != mycred->egid ||
> 	            pcred->sgid != mycred->egid)
> 	                goto not_permitted;
> 	 
> 	        /* the keyrings must have the same UID */
> 	-       if (pcred ->tgcred->session_keyring->uid != mycred->euid ||
> 	+       if (pcred->tgcred->session_keyring->uid != mycred->euid ||
> 	            mycred->tgcred->session_keyring->uid != mycred->euid)
> 	                goto not_permitted;
> 
> _Please_ don't do either of these.  The whole point is to line stuff up so
> that as the eye scans down the lines, it can easily pick out the differences
> in stuff that's otherwise greatly repetitive.
> 
> David
> 

-- 
James Morris
<jmorris@namei.org>
