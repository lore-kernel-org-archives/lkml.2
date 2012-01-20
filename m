Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2ATQI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:08:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32877 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2ATQIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:08:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120120155701.GL8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home> <20120120.232002.849876084731555262.yamato@redhat.com>
 <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com> <20120120155701.GL8797@codelibre.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 20 Jan 2012 17:08:02 +0100
Message-ID: <CAPXgP10_c+JkeGkvHG7O=6-Y=1nQEeBzCwEARSS1us9NJ6hktw@mail.gmail.com>
Subject: Re: /etc/fstab.d yes or not
To: Roger Leigh <rleigh@codelibre.net>
Cc: Masatake YAMATO <yamato@redhat.com>, kzak@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 16:57, Roger Leigh <rleigh@codelibre.net> wrote:
> On Fri, Jan 20, 2012 at 03:56:43PM +0100, Kay Sievers wrote:
>> On Fri, Jan 20, 2012 at 15:20, Masatake YAMATO <yamato@redhat.com> wrote:
>> >>
>> >>  I'd like to add support for /etc/fstab.d to libmount. The library is
>> >>  currently used by mount, umount and mount.nfs. The goal is to use it
>> >>  on more places.
>> >
>> > I'm working on systemd to support /etc/fstab.d.
>>
>> It's an old glibc API, and /etc/fstab is ABI, not a service config
>> file, which now can read more than one file. It's a very different
>> problem. It an ABI change, not a config extension.
>
> I think that's putting the problem a little too strongly.  The
> glibc API is generic: it can (and is) used to parse any file using
> the fstab(5) file format; it's not restricted to only /etc/mtab
> and /etc/fstab.  setmntent(3) accepts any filename.

That's right, but it's just not the way it's used. None of the old
tools is prepared to just wrap that in a readdir() loop.

> You are entirely correct that it may break the assumptions made by
> some software, but it's certainly not "ABI" or even "API" breakage.

It is surely the de-facto Linux/UNIX ABI for system mounts.

>> Tools rightfully expect that they find all system mounts in that file,
>> and not in some new split-up directory. In some cases, fstab is used
>> to 'check if the device is not a system volume', and that will just
>> break now,
>
> The number of tools which do this is tiny, and could (if we wished)
> be patched trivially to also look at the files in fstab.d.
>
> Alternatively, glibc itself could be updated so that if e.g.
> setmntent(3) is called with "/etc/fstab" as its filename argument,
> it will additionally process and include the contents of
> /etc/fstab.d as well.  This would have the advantage of transparency
> for all users of the glibc interface.

That's true, but good luck with glibc changes. :)

Kay
