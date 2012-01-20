Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2ATQNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:13:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52319 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2ATQNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:13:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120120154912.GK8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home> <20120120154912.GK8797@codelibre.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 20 Jan 2012 17:13:12 +0100
Message-ID: <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Roger Leigh <rleigh@codelibre.net>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 16:49, Roger Leigh <rleigh@codelibre.net> wrote:
> On Fri, Jan 20, 2012 at 03:04:44PM +0100, Karel Zak wrote:
>>  I'd like to add support for /etc/fstab.d to libmount. The library is
>>  currently used by mount, umount and mount.nfs. The goal is to use it
>>  on more places.
>>
>>  The /etc/fstab.d directory has been requested by people who maintains
>>  large number of mountpoints etc.
>>
>>  The directory is not replacement for /etc/fstab, it's additional place
>>  where you can describe your filesystems.
>
> As a general comment, I would like to use fstab.d for replacing
> the initscripts which mount kernel filesystems in Debian initscripts
> (sysvinit).  We currently hardcode the logic to mount each filesystem
> and additionally hardcode the defaults, and permit the defaults to
> be overridden by the user via /etc/default/* or via entries in
> /etc/fstab.  This could be done much more straightforwardly using
> entries such as /etc/fstab.d/kernfs and /etc/fstab.d/tmpfs etc.

It is just very wrong to expose kernel filesystems to system mounts.
Please invent your own config if you want that for packaging. The
kernel filesystems do not belong in fstab, and for the same reason not
in fstab.d/.

> From the distributor's POV, this can then take advantage of the
> package manager's conffile handling, meaning it's much simpler
> for the user to customise.
>
> From the initscripts POV, were systemd to also use the same
> approach, we could then share the configuration between the different
> init systems.

The init systems need to handle the mounts, but unlikely by sharing
additional config files. For systemd it is a solved problem, we don't
need fstab.d/ for that, and sysv should not start to try to solve it
at that level, because it will conflict with systemd.

Kay
