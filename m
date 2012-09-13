Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2IMMRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843Ab2IMMRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:17:32 -0400
Date: Thu, 13 Sep 2012 13:16:29 +0100
From: "Daniel P. Berrange" <berrange@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Michal Hocko <mhocko@suse.cz>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913121629.GL7767@redhat.com>
Reply-To: "Daniel P. Berrange" <berrange@redhat.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910223355.GD7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 03:33:55PM -0700, Tejun Heo wrote:
> (forgot cc'ing containers / cgroups mailing lists and used the old
>  address for Li.  Reposting.  Sorry for the noise.)
> 
> Currently, cgroup hierarchy support is a mess.  cpu related subsystems
> behave correctly - configuration, accounting and control on a parent
> properly cover its children.  blkio and freezer completely ignore
> hierarchy and treat all cgroups as if they're directly under the root
> cgroup.  Others show yet different behaviors.
> 
> These differing interpretations of cgroup hierarchy make using cgroup
> confusing and it impossible to co-mount controllers into the same
> hierarchy and obtain sane behavior.
> 
> Eventually, we want full hierarchy support from all subsystems and
> probably a unified hierarchy.  Users using separate hierarchies
> expecting completely different behaviors depending on the mounted
> subsystem is deterimental to making any progress on this front.
> 
> This patch adds cgroup_subsys.broken_hierarchy and sets it to %true
> for controllers which are lacking in hierarchy support.  The goal of
> this patch is two-fold.
> 
> * Move users away from using hierarchy on currently non-hierarchical
>   subsystems, so that implementing proper hierarchy support on those
>   doesn't surprise them.
> 
> * Keep track of which controllers are broken how and nudge the
>   subsystems to implement proper hierarchy support.
> 
> For now, start with a single warning message.  We can whine louder
> later on.

If you want application developers / users to understand this, then
you really need to update the Documentation/cgroups/cgroups.txt file
to provide suitable recommendations on use of hierarchies. As it
stands today it arguably encourages apps to make use of arbitrary
hierarchies. While some of the other docs (blkio-controller.txt) do
describe the limitations of their implementation, they don't ever
go as far as recommending against usage of hierarchies, which is
what you seem to be saying.

Just printing warning messages in the logs with no docs to explain
the issues which cause the warnings is not friendly to users, and
IMHO will just lead people to ignore the warnings.

Regards,
Daniel
-- 
|: http://berrange.com      -o-    http://www.flickr.com/photos/dberrange/ :|
|: http://libvirt.org              -o-             http://virt-manager.org :|
|: http://autobuild.org       -o-         http://search.cpan.org/~danberr/ :|
|: http://entangle-photo.org       -o-       http://live.gnome.org/gtk-vnc :|
