Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1L0Qfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 11:35:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34774 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082Ab1L0Qfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:35:41 -0500
Date: Tue, 27 Dec 2011 08:35:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix to allow mounting a hierarchy by name
Message-ID: <20111227163535.GA17712@google.com>
References: <4EF9291D.7030208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF9291D.7030208@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Dec 27, 2011 at 10:10:37AM +0800, Li Zefan wrote:
> If we mount a hierarchy with a name specified, the name is unique,
> and we can use it to mount the hierarchy without specifying its
> set of subsystem names. This feature is documented is
> Documentation/cgroups/cgroups.txt section 2.3
> 
> Here's an example:
> 
> 	# mount -t cgroup -o cpuset,name=myhier xxx /cgroup1
> 	# mount -t cgroup -o name=myhier xxx /cgroup2
> 
> But it was broken by commit 32a8cf235e2f192eb002755076994525cdbaa35a
> (cgroup: make the mount options parsing more accurate)
> 
> This fixes the regression.

Hmmm... so that has been broken over a year and nobody complained?  Is
there any valid use case where specifying mount path as all other
filesystems wouldn't work?  Is this 'name' thing necessary at all?
Maybe we should rip it out instead of fixing it?  We can just leave it
as non-functional name which does nothing but being visible in mount
listing.

Thanks.

-- 
tejun
