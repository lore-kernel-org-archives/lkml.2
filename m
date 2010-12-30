Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0L3I5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 03:57:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33606 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0L3I5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 03:57:33 -0500
MIME-Version: 1.0
X-Originating-IP: [24.27.19.110]
In-Reply-To: <20101230075901.GA4115@glandium.org>
References: <20101230075901.GA4115@glandium.org>
Date: Thu, 30 Dec 2010 02:57:31 -0600
Message-ID: <AANLkTim-GyefzpYwCqUhoKMQrVFiuE+NKRWYG493ZYP=@mail.gmail.com>
Subject: Re: Containers and /proc/sys/vm/drop_caches
From: Rob Landley <rob@landley.net>
To: Mike Hommey <mh@glandium.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 1:59 AM, Mike Hommey <mh@glandium.org> wrote:
> Hi,
>
> I noticed that from within a lxc container, writing "3" to
> /proc/sys/vm/drop_caches would flush the host page cache. That sounds a
> little dangerous for VPS offerings that would be based on lxc, as in one
> VPS instance root user could impact the overall performance of the host.

There's a containers@vger mailing list for this stuff, you might have better
luck asking there.

> I don't know about other containers but I've been told openvz isn't
> subject to this problem.

I've been coming up to speed on this area recently: openvz has a lot of stuff
that isn't in the main kernel, but it's based on an approach that didn't get
merged into the kernel (using new syscalls to control container stuff).

Instead Google's rewrite of sgi's cgroup stuff went in for process grouping
(based on the cgroup filesystem), and a half-dozen different types of
namespaces are based on flags to clone(), and various other filesystems
(proc, sys, devpts) grew some kind of -o newinstance flag (see
http://lkml.indiana.edu/hypermail//linux/kernel/1012.3/00777.html for a pending
example, although why they can't detect they're the first instance in
the current
container rather than containers having to be specially set up by the host, I
still don't understand yet)... and so on.

The rest of the stuff openvz does is still being redesigned to go into
vanilla based on those mechanisms.  It seems a bit like squashfs: vanilla should
be able to do this someday, but when it gets merged it may not be
compatible with
the out of tree version.  LXC is an attempt to make a userspace tool to drive
containers in the vanilla kernel.  It doesn't do half of what openvz does yet,
but they're working on it.

Rob
