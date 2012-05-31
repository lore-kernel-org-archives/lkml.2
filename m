Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2EaG2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab2EaG2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:28:37 -0400
Message-ID: <1338445696.19369.27.camel@cr0>
Subject: Re: [RFC Patch] fs: implement per-file drop caches
From: Cong Wang <amwang@redhat.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Keiichi Kii <k-keiichi@bx.jp.nec.com>
Date: Thu, 31 May 2012 14:28:16 +0800
In-Reply-To: <20422.14538.833061.105058@quad.stoffel.home>
References: <1338385120-14519-1-git-send-email-amwang@redhat.com>
	 <20422.14538.833061.105058@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 11:12 -0400, John Stoffel wrote:
> Cong> This is a draft patch of implementing per-file drop caches.
> 
> Interesting.  So can I do this from outside a process?  I'm a
> SysAdmin, so my POV is from noticing, finding and fixing performance
> problems when the system is under pressure.  

Yes, sure, we need to write a utility (or patch an existing one) to do
this for you admins.

> 
> Cong> It introduces a new fcntl command  F_DROP_CACHES to drop
> Cong> file caches of a specific file. The reason is that currently
> Cong> we only have a system-wide drop caches interface, it could
> Cong> cause system-wide performance down if we drop all page caches
> Cong> when we actually want to drop the caches of some huge file.
> 
> How can I tell how much cache is used by a file?  And what is the
> performance impact of this when run on a busy system?  And what does
> this patch buy us since I figure the VM should already be dropping
> caches once the system comes under mem pressure...
> 

AFAIK, we don't export such information to user-space, we only have
system-wide statistics.

Keiichi (in Cc) once wrote a patch to implement page cache tracepoint:
http://marc.info/?l=linux-mm&m=131102496904326&w=3

but the patches are still not in upstream.

Thanks!

