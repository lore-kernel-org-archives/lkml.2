Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2GTSKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:10:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44644 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GTSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:10:47 -0400
Date: Fri, 20 Jul 2012 11:10:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 0/3] cgroup: add xattr support
Message-ID: <20120720181041.GK32763@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120717204126.GE24336@google.com>
 <alpine.LSU.2.00.1207181237010.2160@eggly.anvils>
 <20120718221044.GJ24336@google.com>
 <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1207181736020.3323@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Wed, Jul 18, 2012 at 06:11:32PM -0700, Hugh Dickins wrote:
> So systemd is already doing it as I suggested, but finds that awkward in
> some respects, and wants more help from the kernel in synchronization.

Yeah, pretty much.

> Stuffing an unbounded amount of data into cgroupfs xattrs doesn't sound
> the right way to go.
> 
> I wonder if it could be turned completely on its head, and the cgroupfs
> parts be represented in xattrs on a tmpfs hierarchy?  The data contents of
> the tmpfs files being entirely up to userspace i.e. systemd in ths case.

Probably not.  We can't change the userland-visible cgroup interface
and the cgroup filesystem is unfortunately ***DEEPLY*** (yes, it's
crazily deep) entangled with cgroup core implementation. :(

Longer term goal is to factor out sysfs from kobject / driver model
and share it between cgroup and sysfs.  I think it's generally not a
bad idea to support xattr on pseudo filesystems if it isn't too hairy
to support.  Low level system management software should be able to
make pretty good use of them.

Thanks.

-- 
tejun
