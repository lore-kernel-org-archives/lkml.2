Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2ATPEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:04:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61984 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2ATPEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:04:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120120.232002.849876084731555262.yamato@redhat.com>
References: <20120120140444.GC13157@x2.net.home> <20120120.232002.849876084731555262.yamato@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 20 Jan 2012 15:56:43 +0100
Message-ID: <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Masatake YAMATO <yamato@redhat.com>
Cc: kzak@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 15:20, Masatake YAMATO <yamato@redhat.com> wrote:
>>
>>  I'd like to add support for /etc/fstab.d to libmount. The library is
>>  currently used by mount, umount and mount.nfs. The goal is to use it
>>  on more places.
>>
>>  The /etc/fstab.d directory has been requested by people who maintains
>>  large number of mountpoints etc.
>>
>>  The directory is not replacement for /etc/fstab, it's additional place
>>  where you can describe your filesystems.
>>
>>  The disadvantage is that the stuff in the directory will be invisible
>>  for some tools (udisks, systemd, ...), so I have very vocal
>>  disagreement from some people who don't want to see /etc/fstab.d at all.
>
> I'm working on systemd to support /etc/fstab.d.

And we don't want to support that in systemd.

It's an old glibc API, and /etc/fstab is ABI, not a service config
file, which now can read more than one file. It's a very different
problem. It an ABI change, not a config extension.

Tools rightfully expect that they find all system mounts in that file,
and not in some new split-up directory. In some cases, fstab is used
to 'check if the device is not a system volume', and that will just
break now,

The gain of features from fstab.d/ vs. the amount of breakage it
causes is not worth the trouble.

And yes, there are systemd units, but we don't recommend anybody
working with a general purpose system to mount system volumes with
them. They are primarily used for virtual filessytems, which do not
belong in fstab. In special purpose setups, like embedded, which do
not care about POSIX-like APIs, the systemd units can replace fstab,
but it's an entirely different story than breaking fstab expectations.

Kay
