Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2C0WMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:12:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2C0WMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:12:40 -0400
Date: Tue, 27 Mar 2012 15:12:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmap.c: find_vma: remove if(mm) check
Message-Id: <20120327151238.302a5920.akpm@linux-foundation.org>
In-Reply-To: <1332805767-2013-1-git-send-email-consul.kautuk@gmail.com>
References: <1332805767-2013-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 19:49:27 -0400
Kautuk Consul <consul.kautuk@gmail.com> wrote:

> find_vma is called from kernel code where it is absolutely
> sure that the mm_struct arg being passed to it is non-NULL.
> 
> Remove the if(mm) check.

It's odd that the if(mm) test exists - I wonder why it was originally
added.  My repo only goes back ten years, and it's there in 2.4.18.

Any code which calls find_vma() without an mm is surely pretty busted?


Still, I think I'd prefer to do

	if (WARN_ON_ONCE(!mm))
		return NULL;

then let that bake for a kernel release, just to find out if we have a
weird caller out there, such as a function which is called by both user
threads and by kernel threads.
