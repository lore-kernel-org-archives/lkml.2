Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1JXOai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:30:38 -0400
Received: from tundra.namei.org ([65.99.196.166]:46591 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab1JXOah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:30:37 -0400
Date: Tue, 25 Oct 2011 01:30:31 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem updates for 3.2
In-Reply-To: <20111025012003.43d3847ec1284f68e79f9948@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1110250130100.20510@tundra.namei.org>
References: <alpine.LRH.2.00.1110242108540.19271@tundra.namei.org> <CA+55aFxbh9eHYe8cPH2TaTW1t5C6C+z-Bcy+kGhR0Gt=MgMvcQ@mail.gmail.com> <20111025012003.43d3847ec1284f68e79f9948@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011, Stephen Rothwell wrote:

> > So this is reverted in linux-next. I don't know why, but it's a bad
> > sign. Doesn't compile?
> 
> Yeah, this:
> 
> security/smack/smack_lsm.c: In function 'smack_bprm_set_creds':
> security/smack/smack_lsm.c:473:21: error: 'PER_CLEAR_ON_SETID' undeclared (first use in this function)
> 
> Caused by commit 84088ba23929 ("Smack: domain transition protections
> (v3)"). PER_CLEAR_ON_SETID is defined in linux/personality.h which is not
> directly included by the above file.
> 
> It appears to have been fixed in the current version of the tree by this:
> 
> 	Smack: compilation fix

Yep, that's the fix for it.


- James
-- 
James Morris
<jmorris@namei.org>
