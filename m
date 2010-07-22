Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0GVXgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:36:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab0GVXgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:36:03 -0400
Date: Thu, 22 Jul 2010 16:35:54 -0700
From: Greg KH <gregkh@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
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
Message-ID: <20100722233554.GB442@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <20100722193741.GA2688@redhat.com>
 <20100722211856.GA1297@suse.de>
 <20100722212634.GC2688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100722212634.GC2688@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 05:26:34PM -0400, Vivek Goyal wrote:
> On Thu, Jul 22, 2010 at 02:18:56PM -0700, Greg KH wrote:
> > On Thu, Jul 22, 2010 at 03:37:41PM -0400, Vivek Goyal wrote:
> > > On Thu, Jul 22, 2010 at 11:36:15AM -0700, Greg KH wrote:
> > > > On Thu, Jul 22, 2010 at 11:31:07AM -0700, Paul Menage wrote:
> > > > > On Thu, Jul 22, 2010 at 11:26 AM, Greg KH <gregkh@suse.de> wrote:
> > > > > > We really shouldn't be asking userspace to create new root filesystems.
> > > > > > So follow along with all of the other in-kernel filesystems, and provide
> > > > > > a mount point in sysfs.
> > > > > >
> > > > > > For cgroupfs, this should be in /sys/fs/cgroup/  This change provides
> > > > > > that mount point when the cgroup filesystem is registered in the kernel.
> > > > > 
> > > > > But cgroups will typically have multiple mounts, with different
> > > > > resource controllers/options on each mount. That doesn't really fit in
> > > > > with this scheme.
> > > > 
> > > > Really?  I see systems mounting it at /cgroups/ in the filesystem today.
> > > > Where are you expecting it to be mounted at?
> > > > 
> > > 
> > > Greg,
> > > 
> > > [CCing few more folks who might be interested in this dicussion ]
> > > 
> > > We do want to retain facility to mount different controllers at different
> > > mount points. We were discussing the other day that in libvirt we might
> > > want to mount block IO controller and network controller separately as
> > > by default we will not put a new virtual machine in a cgroup of its own
> > > because of the penatly involved.
> > 
> > That's fine, I'm not changing that ability at all.  We just need a
> > "default" mount point for "normal" users.
> > 
> > > For other controllers like cpu, memory etc, libvirt automatically puts
> > > each new virtual machine in a cgroup of own. So this is one use case
> > > where we might want to mount different controllers at different mount
> > > points.
> > > 
> > > For my testing I now always use /cgroup/ and create directories under it
> > > /cgroup/blkio /cgroup/cpu etc and mount controllers on respective
> > > directories.
> > 
> > Lennart and Kay, is this what systemd is doing?  I really don't think we
> > should be adding a root /cgroup/ mount point to the system for something
> > like this.
> > 
> > Maybe /dev/cgroup/ is better to use, as that way users can create
> > sub-mount points easier.  They can't do that in /sys/fs/cgroup/
> 
> The only problem with /dev/cgroup seems to be that it seems little
> unintutive. To me, we have devices under /dev/ dir and cgroups are not
> devices.
> 
> I think people have floated similar threads in the past on lkml with
> various opinions and everybody had their own choices but nothing was
> conclusive. 
> 
> Polluting / definitely sounds odd but it does not look that bad once
> we can't find any other good choices.

I think /sys/fs/cgroup/ is a better choice than polluting /

thanks,

greg k-h
