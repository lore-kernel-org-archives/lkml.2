Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab1KAVTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 17:19:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1KAVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 17:19:42 -0400
Date: Tue, 1 Nov 2011 14:19:15 -0700
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jirislaby@gmail.com>, David Miller <davem@davemloft.net>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] sysfs: Make sysfs_rename safe with sysfs_dirents in
 rbtrees.
Message-ID: <20111101211915.GA20290@suse.de>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
 <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
 <20111025131315.GA1899@suse.de>
 <4EAC8642.3050309@suse.cz>
 <m11utvytg4.fsf@fess.ebiederm.org>
 <4EADB864.3060702@suse.cz>
 <m1mxcgrl7q.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mxcgrl7q.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 07:06:17AM -0700, Eric W. Biederman wrote:
> 
> In sysfs_rename remove the optimization of not calling sysfs_unlink_sibling
> and sysfs_link_sibling if the renamed parent directory is not changing.
> This optimization is no longer valid now that sysfs dirents are stored in an
> rbtree sorted by name.
> 
> Move the assignment of s_ns before the call of sysfs_link_sibling.  With no
> sysfs_dirent fields changing after the call of sysfs_link_sibling this allows
> sysfs_link_sibling to take any of the directory entries into account when
> it builds the rbtrees, and s_ns looks like a prime canidate to be used
> in the rbtree in the future.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Looks good, Linus, thanks for taking this in your tree already.

greg k-h
