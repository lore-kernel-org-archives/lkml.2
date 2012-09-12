Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2ILUji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:39:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50251 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab2ILUjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:39:33 -0400
Date: Wed, 12 Sep 2012 21:39:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Andi Kleen <andi@firstfloor.org>
Cc: pkg-sysvinit-devel@lists.alioth.debian.org, debian-devel@lists.debian.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Message-ID: <20120912203921.GY29217@decadent.org.uk>
References: <20120912161154.GB3289@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912161154.GB3289@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: (fwd) make tar*-pkg considered dangerous
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 01:11:54PM -0300, Henrique de Moraes Holschuh wrote:
> I am forwarding this as a remider that, should we ever get to the point of
> moving around /lib or /usr/lib, /sbin or /usr/sbin, and /bin or /usr/sbin,
> as well as any other such trunks, we really ought to consider whether we
> should be using symlinks or bind mounts [where possible] for such moves.
> 
> Also, just in case, Debian users are gently reminded that there are less
> unsavory methods of packing custom kernel builds for later use in Debian
> boxes, including the Linux upstream "deb-pkg" make target (dpkg is a lot
> smarter than "tar"), and the make-kpkg command provided by the
> kernel-package Debian package (which IMHO tends to produce better kernel
> .deb packages than the upstream "deb-pkg" make target.

kernel-package is effectively unmaintained, so please don't recommend
its use unless you intend to rectify that.

> ----- Forwarded message from Andi Kleen <andi@firstfloor.org> -----
> Date: Wed, 12 Sep 2012 05:16:46 +0200
> From: Andi Kleen <andi@firstfloor.org>
> To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
> Subject: make tar*-pkg considered dangerous
> 
> Hi,
> 
> We've had some incidents with people destroying Fedore 17 installs
> (to the point of reinstall) by installing a kernel tarball generated with 
> make tar*-pkg
> 
> The problem is that the tarball includes /lib/{modules,firmware},
> but on FC17 /lib is a symlink. tar when it unpacks the tarball
> replaces the symlink with the directory.
[...]

Presumably the tarball also contains an entry for the directory lib,
and that (not the subdirectory entries) triggers tar to replace the
symlink.  So this can be fixed by only including
lib/{modules,firmware} in the tarball, not lib.

A quick experiment under F16 (tar 1.26) supports this.
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
