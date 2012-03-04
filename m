Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2CDSF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 13:05:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50145 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2CDSF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 13:05:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.190.42 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Sun, 4 Mar 2012 10:05:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2 0/3] cgroup: add xattr support
Message-ID: <20120304180516.GB20787@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F4F1459.4080300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4F1459.4080300@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

Sorry about the delay.  Was on vacation.

On Thu, Mar 01, 2012 at 02:16:57PM +0800, Li Zefan wrote:
> This can be used to attach metadata to a cgroup, which is required
> by systemd.
> 
> As lazy as I am, here just quoted from Lennart for the detailed use
> cases:

I much prefer this version but would prefer to deal with this in the
next merge window as we're already on rc6.  On a cursory look...

* I'm not sure kmem_ is a good prefix.  It sucks that xattr values are
  stored in kmem w/o size limit and we probably want to improve on
  both fronts in the future.  Wouldn't it be better to name them
  simple_*() and put them in fs/libfs.c?

* I don't think we want CONFIG option for cgroupfs xattr.  Let's just
  add a mount option.

Thanks.

-- 
tejun
