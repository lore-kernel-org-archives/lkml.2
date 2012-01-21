Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2AUC7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:59:54 -0500
Received: from tango.0pointer.de ([85.214.72.216]:54257 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796Ab2AUC7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:59:50 -0500
Date: Sat, 21 Jan 2012 03:59:46 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120121025946.GD2100@tango.0pointer.de>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
 <20120118213638.GA21533@google.com>
 <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119022005.GG21533@google.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18.01.12 18:20, Tejun Heo (tj@kernel.org) wrote:

Heya,

> * Probably I'm missing something but isn't the systemd cgroup
>   hierarchy already managed by systemd?  If so, I don't see how
>   managing tmpfs on the side would noticeably make things more
>   fragile.  It would take a bit more care after, for example, restart
>   but it shouldn't be too complex, no?

Well, it becomes more complex, for example, if we miss a cgroups event,
or we go away and come back (i.e. systemd can reexecute itself for
upgrades), and as soon as it isn't just systemd anymore which needs meta
data attached to a cgroup, but we need something shared. For example,
the logic described in
http://www.freedesktop.org/wiki/Software/systemd/PaxControlGroups
regarding "persistant" cgroups would be much nicer using xattrs (it
currently misuses the sticky bit as flag instead).

It's just much nicer if meta data doesn't get stale just because the
process owning it goes awol. And if process want to share meta data, too.
 
> * FS attributes already being used for userland information seems like
>   a good argument, but we shouldn't add separate specialized xattr
>   implementation to different pseudo filesystems.  For it to be
>   acceptable, it should be a libfs thing easily applicable to any
>   pseudo FS and definitely shouldn't be using kmem for storage.

I think the code that was recently added to tmpfs for the same purposes
was supposed to be reusable on other virtual file systems. Might be
worth looking into that.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
