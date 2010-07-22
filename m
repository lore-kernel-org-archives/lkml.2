Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab0GVTig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 15:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0GVTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 15:38:34 -0400
Date: Thu, 22 Jul 2010 15:37:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Jan Safranek <jsafrane@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100722193741.GA2688@redhat.com>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100722183614.GA5443@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 11:36:15AM -0700, Greg KH wrote:
> On Thu, Jul 22, 2010 at 11:31:07AM -0700, Paul Menage wrote:
> > On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
> > > We really shouldn't be asking userspace to create new root filesystems.
> > > So follow along with all of the other in-kernel filesystems, and provide
> > > a mount point in sysfs.
> > >
> > > For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
> > > that mount point when the cgroup filesystem is registered in the kernel.
> > 
> > But cgroups will typically have multiple mounts, with different
> > resource controllers/options on each mount. That doesn't really fit in
> > with this scheme.
> 
> Really?  I see systems mounting it at /cgroups/ in the filesystem today.
> Where are you expecting it to be mounted at?
> 

Greg,

[CCing few more folks who might be interested in this dicussion ]

We do want to retain facility to mount different controllers at different
mount points. We were discussing the other day that in libvirt we might
want to mount block IO controller and network controller separately as
by default we will not put a new virtual machine in a cgroup of its own
because of the penatly involved.

For other controllers like cpu, memory etc, libvirt automatically puts
each new virtual machine in a cgroup of own. So this is one use case
where we might want to mount different controllers at different mount
points.

For my testing I now always use /cgroup/ and create directories under it
/cgroup/blkio /cgroup/cpu etc and mount controllers on respective
directories.

Thanks
Vivek

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
