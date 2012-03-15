Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032189Ab2COTdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 15:33:40 -0400
Received: from tango.0pointer.de ([85.214.72.216]:39296 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420Ab2COTdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 15:33:35 -0400
Date: Thu, 15 Mar 2012 20:33:32 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] cgroup: deprecate remount option changes and "name="
  mount option
Message-ID: <20120315193330.GC32661@tango.0pointer.de>
References: <20120314215228.GI7349@google.com>
 <20120314232925.GA16973@tango.0pointer.de>
 <20120315165402.GC32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165402.GC32137@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15.03.12 09:54, Tejun Heo (tj@kernel.org) wrote:

> 
> Hello,
> 
> On Thu, Mar 15, 2012 at 12:29:25AM +0100, Lennart Poettering wrote:
> > Hmm, this is not clear to me. Are you intending to remove the name=
> > mount option entirely, or just intend to remove that you can change it
> > in remounts?
> > 
> > systemd uses name=systemd to get its own private cgroup tree, that has
> > no controller bound, hence we kinda need this option. Or are you
> > suggesting there was an other way to get a private cgroup tree that
> > systemd can use for grouping and labelling things?
> 
> Eh, you're right.  I want to remove support for duplicate mounting by
> name or subsys as it just isn't necessary, so what I want is,
> 
> * "mount -t cgroupfs -o SUBSYS" will fail if SUBSYS is already mounted
>   somewhere else.
> 
> * "mount -t cgroupfs -o none" will always create a new cgroup
>   hierarchy w/o any controller attached.
> 
> I didn't realize that the mount code didn't allow none w/o name and
> now I don't see a non-intrusive way to remove the name option. :( Eh
> well, I'll drop that part.

Insisting on a name or controller (i.e. not allowing completely
anonymous cgroupfs mounts) is probably a good idea since otherwise the
data in /proc/$PID/cgroup might be a bit useless since you couldn't
sensible match up the data in there with your mount point.

Multiple mounts of the same tree can go, as long as bind mounting is
still supported so that we can make the cgroup tree available in limited
form to containers and such.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
