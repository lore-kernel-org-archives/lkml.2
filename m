Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0F1XCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:02:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:51669 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029Ab0F1XCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:02:08 -0400
Date: Tue, 29 Jun 2010 09:01:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org, justinmattock@gmail.com
Subject: Re: [Keyrings] [PATCH] KEYS: Use the variable 'key' in
 keyctl_describe_key()
In-Reply-To: <20100628130504.9134.11866.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.1006290901400.5933@tundra.namei.org>
References: <1277621246-10960-2-git-send-email-justinmattock@gmail.com> <20100628130504.9134.11866.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, David Howells wrote:

> keyctl_describe_key() turns the key reference it gets into a usable key pointer
> and assigns that to a variable called 'key', which it then ignores in favour of
> recomputing the key pointer each time it needs it.  Make it use the precomputed
> pointer instead.
> 
> Without this patch, gcc 4.6 reports that the variable key is set but not used:
> 
> 	building with gcc 4.6 I'm getting a warning message:
> 	 CC      security/keys/keyctl.o
> 	security/keys/keyctl.c: In function 'keyctl_describe_key':
> 	security/keys/keyctl.c:472:14: warning: variable 'key' set but not used
> 
> Reported-by: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
