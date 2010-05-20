Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0ETIdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:33:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42286 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0ETIdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:33:43 -0400
Date: Thu, 20 May 2010 04:33:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: chris.mason@oracle.com, "Yan, Zheng" <zheng.yan@oracle.com>,
       linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: should add a permission check for setfacl
Message-ID: <20100520083340.GC11920@infradead.org>
References: <4BF1E458.7060500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF1E458.7060500@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 08:50:32AM +0800, Shi Weihua wrote:
> On btrfs, do the following
> ------------------
> # su user1
> # cd btrfs-part/
> # touch aaa
> # getfacl aaa
>   # file: aaa
>   # owner: user1
>   # group: user1
>   user::rw-
>   group::rw-
>   other::r--
> # su user2
> # cd btrfs-part/
> # setfacl -m u::rwx aaa
> # getfacl aaa
>   # file: aaa
>   # owner: user1
>   # group: user1
>   user::rwx           <- successed to setfacl
>   group::rw-
>   other::r--
> ------------------
> but we should prohibit it that user2 changing user1's acl.
> In fact, on ext3 and other fs, a message occurs:
>   setfacl: aaa: Operation not permitted

Can you add this as a new testcase to xfstests so that we can easiy
check for regressions and future filesystems implementing this
correctly?

