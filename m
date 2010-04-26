Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0DZXKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:10:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab0DZXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:10:10 -0400
Date: Mon, 26 Apr 2010 16:09:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: The request_key() syscall should link an existing
 key to the dest keyring
Message-Id: <20100426160918.6f624d86.akpm@linux-foundation.org>
In-Reply-To: <20100426154441.26028.52967.stgit@warthog.procyon.org.uk>
References: <20100426154441.26028.52967.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 16:44:41 +0100
David Howells <dhowells@redhat.com> wrote:

> The request_key() system call and request_key_and_link() should make a link
> from an existing key to the destination keyring (if supplied), not just from a
> new key to the destination keyring.
> 
> This can be tested by:
> 
> 	ring=`keyctl newring fred @s`
> 	keyctl request2 user debug:a a
> 	keyctl request user debug:a $ring
> 	keyctl list $ring
> 
> If it says:
> 
> 	keyring is empty
> 
> then it didn't work.  If it shows something like:
> 
> 	1 key in keyring:
> 	1070462727: --alswrv     0     0 user: debug:a
> 
> then it did.
> 

I don't think I understand that description.  Are you saying that the
patch switches things from the first example output into the second case?

Is the fix needed in -stable?

