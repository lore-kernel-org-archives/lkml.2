Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2ARRrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:47:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54472 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2ARRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:47:37 -0500
Date: Wed, 18 Jan 2012 09:47:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120118174732.GG30664@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <4F168266.3060205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F168266.3060205@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 04:27:18PM +0800, Li Zefan wrote:
> Furthermore, I noticed tmpfs also implemented xattr support, and we
> should be able to share most of the code, which makes the cost for
> having this feature smaller.

Yes, maybe, but tmpfs doesn't have any special semantics attached to
files.  It's supposed to store opaque data from userland.  Regardless
of code complexity, I just don't think this is a good idea.  What if
we later want to attach certain config meaning to or export statistics
via xattrs?  That would be quite unusual and require strong rationale
but at least fall in the similar usage as with the rest of the fs.

Thanks.

-- 
tejun
