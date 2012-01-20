Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2ATQWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:22:23 -0500
Received: from nagini.codelibre.net ([80.68.93.164]:35750 "EHLO
	nagini.codelibre.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2ATQWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:22:22 -0500
Date: Fri, 20 Jan 2012 16:22:20 +0000
From: Roger Leigh <rleigh@codelibre.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120120162220.GN8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home>
 <20120120154912.GK8797@codelibre.net>
 <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP13a9v+f1uNdpe-c+aApLfLpgn15b1-gZxRPd0wMvU=B-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 05:13:12PM +0100, Kay Sievers wrote:
> On Fri, Jan 20, 2012 at 16:49, Roger Leigh <rleigh@codelibre.net> wrote:
> > On Fri, Jan 20, 2012 at 03:04:44PM +0100, Karel Zak wrote:
> >>  I'd like to add support for /etc/fstab.d to libmount. The library is
> >>  currently used by mount, umount and mount.nfs. The goal is to use it
> >>  on more places.
> >>
> >>  The /etc/fstab.d directory has been requested by people who maintains
> >>  large number of mountpoints etc.
> >>
> >>  The directory is not replacement for /etc/fstab, it's additional place
> >>  where you can describe your filesystems.
> >
> > As a general comment, I would like to use fstab.d for replacing
> > the initscripts which mount kernel filesystems in Debian initscripts
> > (sysvinit).  We currently hardcode the logic to mount each filesystem
> > and additionally hardcode the defaults, and permit the defaults to
> > be overridden by the user via /etc/default/* or via entries in
> > /etc/fstab.  This could be done much more straightforwardly using
> > entries such as /etc/fstab.d/kernfs and /etc/fstab.d/tmpfs etc.
> 
> It is just very wrong to expose kernel filesystems to system mounts.
> Please invent your own config if you want that for packaging. The
> kernel filesystems do not belong in fstab, and for the same reason not
> in fstab.d/.

To be fair, these can be split into two categories: kernel filesystems
such as procfs, sysfs etc., and special-purpose tmpfs mounts.  The
former could be kept in the init scripts, but the latter are commonly
required to be customised (or disabled) by admins, and the fstab format
is the natural way to express this.  This would include tmpfs mounts
for e.g. /run, /run/lock, /run/shm, potentially /tmp] and others, each
of which has separate limits.

Inventing custom file formats for these (as is the current situation)
is both opaque to the admin and less amenable to preservation/upgrading
of the admins customisations and the defaults.


Regards,
Roger

-- 
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.
