Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab2EVBwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:52:10 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:59644 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2EVBv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:51:57 -0400
Date: Tue, 22 May 2012 01:54:26 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org,
        Amos Kong <akong@redhat.com>
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
Message-ID: <20120522015426.GA10344@mail.hallyn.com>
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
 <20120518081912.16779.21065.stgit@t>
 <20120521140324.GA5091@sergelap>
 <4FBADF1A.6040303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBADF1A.6040303@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Li Zefan (lizefan@huawei.com):
> Serge Hallyn wrote:
> 
> > Quoting Amos Kong (akong@redhat.com):
> >> @ mount -t cgroup -o devices none /cgroup
> >> @ mkdir /cgroups/devices
> >> @ ls -l /dev/dm-3
> >>  brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
> >> @ echo 'b 253:3 rw' > devices.deny
> >> but I can still write it by 'dd if=/dev/zero of=/dev/dm-3'
> >>
> >> In devcgroup_create(), we create a new whitelist, and add first
> >> entry which type is 'DEV_ALL'. Execute "# echo 'b 253:3 rw' >
> >> devices.deny", dev_whitelist_rm() will update access of first
> >> entry to 1(m), but type of first entry is still 'DEV_ALL'.
> > 
> > Hi,
> > 
> > thanks.  You raise a good point, but I think it needs some discussion.
> > 
> > What happens right now is that if you have the 'a *:* rwm' entry and do
> > echo 'b 253:3 rw' > devices.deny, then when you next cat devices.list you
> > will still see the 'a *:* rwm' entry.  So there should be no confusion
> > over why the dd succeeds.  You didn't remove the entry, because there
> > was no match echoed into devices.deny.
> 
> 
> No, you'll see the entry has been changed to 'a *:* m', so I think we
> should at least fix this.

Yikes.  Agreed.  That's a bug.

thanks,
-serge
