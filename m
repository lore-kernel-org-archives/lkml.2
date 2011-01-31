Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1AaT4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:56:16 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:65000 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab1AaT4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:56:15 -0500
Subject: Re: [PATCH 2/2] RFC: selinux: sysctl: fix selinux labeling broken
 by last patch
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux <selinux@tycho.nsa.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1296498940.26427.42.camel@moss-pluto>
References: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com>
	 <1296482354.26427.21.camel@moss-pluto>
	 <AANLkTimt5sxmgUmn-i-WcgMN4d0X00YVMujsA4QgS8nX@mail.gmail.com>
	 <1296493175.26427.37.camel@moss-pluto>
	 <AANLkTi=3z-en0HAgVx1hRKrj6KYOHi_ZUP4aDv=8zUaa@mail.gmail.com>
	 <1296498940.26427.42.camel@moss-pluto>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Mon, 31 Jan 2011 14:55:52 -0500
Message-ID: <1296503752.26427.50.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 13:35 -0500, Stephen Smalley wrote:
> On Mon, 2011-01-31 at 19:03 +0200, Lucian Adrian Grijincu wrote:
> > On Mon, Jan 31, 2011 at 6:59 PM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > > /proc/sys inode labeling was disabled earlier (hence marked S_PRIVATE)
> > > when /proc/sys was reimplemented by Eric, so all access control
> > > on /proc/sys was switched to using the sysctl hook rather than the
> > > inode-based checking.  That's why you don't get a result from ls -Z
> > > on /proc/sys on current kernels.  Getting actual labeling working again
> > > for those inodes would be a win, so your patch is an improvement in that
> > > regard for selinux.
> > 
> > 
> > Oh, OK. Thanks for letting me know.
> > 
> > Do you see anything else that is wrong with these patches (apart from
> > "//deleted")?
> 
> No, although I think someone should take them for a spin on a modern
> Fedora in enforcing mode for a bit, and likely run the selinux testsuite
> too.

Booting F14 with your patch applied yields a large number of AVC denials
of the form:
type=AVC msg=audit(1296503592.932:1220139): avc:  denied  { read } for
pid=1896 comm="gnome-settings-" path="anon_inode:inotify"
dev=anon_inodefs ino=5312
scontext=system_u:system_r:xdm_t:s0-s0:c0.c1023
tcontext=system_u:object_r:unlabeled_t:s0 tclass=file

So I assume that the anon_inodefs inodes are being marked private too,
and relying on that test within inode_has_perm to avoid permission
checks.  Which would mean that you need to leave that test alone after
all.

The /proc labeling looks good though.

-- 
Stephen Smalley
National Security Agency

