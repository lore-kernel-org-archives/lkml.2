Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2ATSFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 13:05:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47242 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab2ATSFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 13:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120120162220.GN8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home> <20120120154912.GK8797@codelibre.net>
 <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com> <20120120162220.GN8797@codelibre.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 20 Jan 2012 18:59:47 +0100
Message-ID: <CAPXgP11pvch92n1=mMfDsMLoGZMG8xq0e1juXyUO6mxFR6_GYg@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Roger Leigh <rleigh@codelibre.net>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 17:22, Roger Leigh <rleigh@codelibre.net> wrote:
> On Fri, Jan 20, 2012 at 05:13:12PM +0100, Kay Sievers wrote:
>> On Fri, Jan 20, 2012 at 16:49, Roger Leigh <rleigh@codelibre.net> wrote:
>> > On Fri, Jan 20, 2012 at 03:04:44PM +0100, Karel Zak wrote:
>> >>  I'd like to add support for /etc/fstab.d to libmount. The library is
>> >>  currently used by mount, umount and mount.nfs. The goal is to use it
>> >>  on more places.
>> >>
>> >>  The /etc/fstab.d directory has been requested by people who maintains
>> >>  large number of mountpoints etc.
>> >>
>> >>  The directory is not replacement for /etc/fstab, it's additional place
>> >>  where you can describe your filesystems.
>> >
>> > As a general comment, I would like to use fstab.d for replacing
>> > the initscripts which mount kernel filesystems in Debian initscripts
>> > (sysvinit).  We currently hardcode the logic to mount each filesystem
>> > and additionally hardcode the defaults, and permit the defaults to
>> > be overridden by the user via /etc/default/* or via entries in
>> > /etc/fstab.  This could be done much more straightforwardly using
>> > entries such as /etc/fstab.d/kernfs and /etc/fstab.d/tmpfs etc.
>>
>> It is just very wrong to expose kernel filesystems to system mounts.
>> Please invent your own config if you want that for packaging. The
>> kernel filesystems do not belong in fstab, and for the same reason not
>> in fstab.d/.
>
> To be fair, these can be split into two categories: kernel filesystems
> such as procfs, sysfs etc., and special-purpose tmpfs mounts.  The
> former could be kept in the init scripts, but the latter are commonly
> required to be customised (or disabled) by admins, and the fstab format
> is the natural way to express this.  This would include tmpfs mounts
> for e.g. /run, /run/lock, /run/shm, potentially /tmp] and others, each
> of which has separate limits.
>
> Inventing custom file formats for these (as is the current situation)
> is both opaque to the admin and less amenable to preservation/upgrading
> of the admins customisations and the defaults.

I'm not talking about custom file formats, better just add a mount -c,
and do mount -c /etc/kernelfs.d/*.conf, or whatever will fit systemv
needs.

This is nothing really to share between systemd and systemv here. This
problem just does not exist for systemd.

And for systemv it should not be solved in mount(8), but in a systemv
specific part.

A change in common tools at that level breaks much more than it solves.

Kay
