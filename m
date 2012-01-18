Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2ARV3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:29:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33089 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2ARV3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:29:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120117175322.GC6762@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Jan 2012 22:28:42 +0100
Message-ID: <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 18:53, Tejun Heo <tj@kernel.org> wrote:

>> > The key idea is that this would allow attaching runtime meta information
>> > to cgroups and everything they model (services, apps, vms), that doesn't
>> > need any complex userspace infrastructure, has good access control
>> > (i.e. because the file system enforces that anyway, and there's the
>> > "trusted." xattr namespace), notifications (inotify), and can easily be
>> > shared among applications.

> Ummm... I don't feel too good about this.  Why can't those extra
> information be kept somewhere else?  Overloading cgroupfs as storage
> for essentially opaque userland information doesn't seem like a good
> idea to me.

A bit of the background:

The /sys/fs/cgroup/systemd/ hierarchy represents something like a
first class kernel-related system object, which we call an
'application' or 'service' in userspace. Every 'service' or
'application' has zero, one or many processes, and has some high-level
metadata attached.

The general idea, not specifcally related to cgroups, is to try as
hard as possible to stick metadata about objects to the objects
themselves. It's a bit like the difference of lock files vs. locks
attached to a process. In the later case, if the process dies, the
lock is automatically cleaned up, in the former, we have a stale file.

The idea with the cgroup fs xattrs was to be able to attach some
general useful attributes to the 'service container' itself, instead
of keeping them in the memory of the managing process or store them on
disk which can get out-of-sync much easier.

Kay
