Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2ATP5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:57:19 -0500
Received: from nagini.codelibre.net ([80.68.93.164]:38165 "EHLO
	nagini.codelibre.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2ATP5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:57:16 -0500
Date: Fri, 20 Jan 2012 15:49:12 +0000
From: Roger Leigh <rleigh@codelibre.net>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120120154912.GK8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120140444.GC13157@x2.net.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 03:04:44PM +0100, Karel Zak wrote:
>  I'd like to add support for /etc/fstab.d to libmount. The library is
>  currently used by mount, umount and mount.nfs. The goal is to use it
>  on more places.
> 
>  The /etc/fstab.d directory has been requested by people who maintains
>  large number of mountpoints etc.
> 
>  The directory is not replacement for /etc/fstab, it's additional place
>  where you can describe your filesystems.

As a general comment, I would like to use fstab.d for replacing
the initscripts which mount kernel filesystems in Debian initscripts
(sysvinit).  We currently hardcode the logic to mount each filesystem
and additionally hardcode the defaults, and permit the defaults to
be overridden by the user via /etc/default/* or via entries in
/etc/fstab.  This could be done much more straightforwardly using
entries such as /etc/fstab.d/kernfs and /etc/fstab.d/tmpfs etc.

>From the distributor's POV, this can then take advantage of the
package manager's conffile handling, meaning it's much simpler
for the user to customise.

>From the initscripts POV, were systemd to also use the same
approach, we could then share the configuration between the different
init systems.

Note that I've not actually taken any of these steps yet; I'm
about to test it with the upcoming util-linux release and the
current prerelease, but it is something under consideration.


Regards,
Roger

-- 
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.
