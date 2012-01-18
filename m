Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab2ARIYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:24:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63226 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab2ARIYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:24:50 -0500
Message-ID: <4F168266.3060205@cn.fujitsu.com>
Date: Wed, 18 Jan 2012 16:27:18 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com> <20120117175322.GC6762@google.com>
In-Reply-To: <20120117175322.GC6762@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-18 16:23:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-18 16:23:37,
	Serialize complete at 2012-01-18 16:23:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 16, 2012 at 04:07:05PM +0800, Li Zefan wrote:
>> This is one of the items in the plumber's wish list.
>>
>> For use cases:
>>
>>>> What would the use case be for this?
>>>
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
>>>
>>> Lennart
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Ummm... I don't feel too good about this.  Why can't those extra
> information be kept somewhere else?  Overloading cgroupfs as storage
> for essentially opaque userland information doesn't seem like a good
> idea to me.
> 

Long ago Paul M toyed with a patch that adds a control file for userspace
to read/write per-cgroup user information, but there were no use cases.
This patchset has a similar purpose, but this interface is more flexable
and easier to use, and we do have systemd as a use case this time.

I'll let Lennart answer if we can easily live without this.

Furthermore, I noticed tmpfs also implemented xattr support, and we
should be able to share most of the code, which makes the cost for
having this feature smaller.
