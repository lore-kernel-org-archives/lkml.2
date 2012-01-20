Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2ATP5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:57:06 -0500
Received: from nagini.codelibre.net ([80.68.93.164]:38164 "EHLO
	nagini.codelibre.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab2ATP5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:57:04 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jan 2012 10:57:04 EST
Date: Fri, 20 Jan 2012 15:57:01 +0000
From: Roger Leigh <rleigh@codelibre.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Masatake YAMATO <yamato@redhat.com>, kzak@redhat.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: /etc/fstab.d yes or not
Message-ID: <20120120155701.GL8797@codelibre.net>
References: <20120120140444.GC13157@x2.net.home>
 <20120120.232002.849876084731555262.yamato@redhat.com>
 <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP10uUpSQzX0RzYY24uDBkNkRXM7NbR0H6P=dZ=+LxdX3Fw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 03:56:43PM +0100, Kay Sievers wrote:
> On Fri, Jan 20, 2012 at 15:20, Masatake YAMATO <yamato@redhat.com> wrote:
> >>
> >>  I'd like to add support for /etc/fstab.d to libmount. The library is
> >>  currently used by mount, umount and mount.nfs. The goal is to use it
> >>  on more places.
> >
> > I'm working on systemd to support /etc/fstab.d.
> 
> It's an old glibc API, and /etc/fstab is ABI, not a service config
> file, which now can read more than one file. It's a very different
> problem. It an ABI change, not a config extension.

I think that's putting the problem a little too strongly.  The
glibc API is generic: it can (and is) used to parse any file using
the fstab(5) file format; it's not restricted to only /etc/mtab
and /etc/fstab.  setmntent(3) accepts any filename.

You are entirely correct that it may break the assumptions made by
some software, but it's certainly not "ABI" or even "API" breakage.

> Tools rightfully expect that they find all system mounts in that file,
> and not in some new split-up directory. In some cases, fstab is used
> to 'check if the device is not a system volume', and that will just
> break now,

The number of tools which do this is tiny, and could (if we wished)
be patched trivially to also look at the files in fstab.d.

Alternatively, glibc itself could be updated so that if e.g.
setmntent(3) is called with "/etc/fstab" as its filename argument,
it will additionally process and include the contents of
/etc/fstab.d as well.  This would have the advantage of transparency
for all users of the glibc interface.


Regards,
Roger

-- 
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.
