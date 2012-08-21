Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab2HUVoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 17:44:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758482Ab2HUVoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 17:44:30 -0400
Message-ID: <50340110.50607@redhat.com>
Date: Tue, 21 Aug 2012 23:43:44 +0200
From: Lennart Poettering <lpoetter@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120801 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: aris@redhat.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
References: <20120816174453.154143248@napanee.usersys.redhat.com> <20120816174454.087507415@napanee.usersys.redhat.com> <20120816200006.GG24861@google.com>
In-Reply-To: <20120816200006.GG24861@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

(sorry for the late reply)

On 16.08.2012 22:00, Tejun Heo wrote:
> On Thu, Aug 16, 2012 at 01:44:56PM -0400, aris@redhat.com wrote:

>>> Attaching meta information to services, in an easily discoverable
>>> way. For example, in systemd we create one cgroup for each service, and
>>> could then store data like the main pid of the specific service as an
>>> xattr on the cgroup itself. That way we'd have almost all service state
>>> in the cgroupfs, which would make it possible to terminate systemd and
>>> later restart it without losing any state information. But there's more:
>>> for example, some very peculiar services cannot be terminated on
>>> shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
>>> services in question could just mark that on their cgroup, by setting an
>>> xattr. On the more desktopy side of things there are other
>>> possibilities: for example there are plans defining what an application
>>> is along the lines of a cgroup (i.e. an app being a collection of
>>> processes). With xattrs one could then attach an icon or human readable
>>> program name on the cgroup.
>>>
>>> The key idea is that this would allow attaching runtime meta information
>>> to cgroups and everything they model (services, apps, vms), that doesn't
>>> need any complex userspace infrastructure, has good access control
>>> (i.e. because the file system enforces that anyway, and there's the
>>> "trusted." xattr namespace), notifications (inotify), and can easily be
>>> shared among applications.

>
> I'm not against this but unsure whether using kmem is enough for the
> suggested use case.  Lennart, would this suit systemd?  How much
> metadata are we talking about?

Just small things, like values, PIDs, i.e. a few 100 bytes or so per 
cgroup should be more than sufficient for our needs.

Lennart
