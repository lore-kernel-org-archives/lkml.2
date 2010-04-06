Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0DFTnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:43:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649Ab0DFTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:43:25 -0400
Date: Tue, 6 Apr 2010 12:39:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, npiggin@suse.de, paulmck@linux.vnet.ibm.com,
       corbet@lwn.net, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make
 out
In-Reply-To: <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.1004061236290.3487@i5.linux-foundation.org>
References: <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Apr 2010, David Howells wrote:
>
> radix_tree_tag_get() is not safe to use concurrently with radix_tree_tag_set()
> or radix_tree_tag_clear().  The problem is that the double tag_get() in
> radix_tree_tag_get():
 [ snip snip ]

Looks like a reasonable patch, but the one thing you didn't say is whether 
there is any code that relies on the incorrectly documented behavior?

How did you find this? Do we need to fix actual code too? The only user 
seems to be your fscache/page.c thing, and I'm not seeing any locking 
except for the rcu locking that is apparently not sufficient.

			Linus
