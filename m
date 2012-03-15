Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031957Ab2COQyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:54:10 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63763 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031805Ab2COQyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:07 -0400
Date: Thu, 15 Mar 2012 09:54:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
 mount option
Message-ID: <20120315165402.GC32137@google.com>
References: <20120314215228.GI7349@google.com>
 <20120314232925.GA16973@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314232925.GA16973@tango.0pointer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 15, 2012 at 12:29:25AM +0100, Lennart Poettering wrote:
> Hmm, this is not clear to me. Are you intending to remove the name=
> mount option entirely, or just intend to remove that you can change it
> in remounts?
> 
> systemd uses name=systemd to get its own private cgroup tree, that has
> no controller bound, hence we kinda need this option. Or are you
> suggesting there was an other way to get a private cgroup tree that
> systemd can use for grouping and labelling things?

Eh, you're right.  I want to remove support for duplicate mounting by
name or subsys as it just isn't necessary, so what I want is,

* "mount -t cgroupfs -o SUBSYS" will fail if SUBSYS is already mounted
  somewhere else.

* "mount -t cgroupfs -o none" will always create a new cgroup
  hierarchy w/o any controller attached.

I didn't realize that the mount code didn't allow none w/o name and
now I don't see a non-intrusive way to remove the name option. :( Eh
well, I'll drop that part.

Thanks.

-- 
tejun
