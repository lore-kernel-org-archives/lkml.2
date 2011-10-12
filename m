Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1JLTFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 15:05:01 -0400
Received: from fieldses.org ([174.143.236.118]:47154 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1JLTFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 15:05:00 -0400
Date: Wed, 12 Oct 2011 15:04:52 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Theodore Tso <tytso@mit.edu>,
        Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: Detecting if you are running in a container
Message-ID: <20111012190452.GA23845@fieldses.org>
References: <20111010163140.GA22191@tango.0pointer.de>
 <m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
 <20111011013201.GA7948@thunk.org>
 <20111011020530.GG16723@count0.beaverton.ibm.com>
 <20111011032523.GB7948@thunk.org>
 <m1ty7ghvvn.fsf@fess.ebiederm.org>
 <203BBB0D-293D-4BFB-A57B-41C56F58F9B3@mit.edu>
 <m17h4bfcuv.fsf@fess.ebiederm.org>
 <20111012175702.GA23231@fieldses.org>
 <CAGZ=bqJxadNqaPCW3HufrMmQ57x082=pCDa6-mWLsdtfxHgdPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGZ=bqJxadNqaPCW3HufrMmQ57x082=pCDa6-mWLsdtfxHgdPw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:25:04PM -0400, Kyle Moffett wrote:
> On Wed, Oct 12, 2011 at 13:57, J. Bruce Fields <bfields@fieldses.org> wrote:
> > On Tue, Oct 11, 2011 at 02:16:24PM -0700, Eric W. Biederman wrote:
> >> Where all of this winds up interesting in the field of oncoming kernel
> >> work is that uids are persistent and are stored in file systems.  So
> >> once we have all of the permission checks in the kernel tweaked to care
> >> about user namespaces we next look at the filesystems.   The easy
> >> initial implementation is going to be just associating a user namespace
> >> with a super block.  But farther out being able to store uids from
> >> different user namespaces on the same filesystem becomes an interesting
> >> problem.
> >
> > Yipes.  Why would anyone want to do that?
> 
> Consider an NFS file server providing collaborative access to multiple
> independently managed domains (EG: several different universities),
> each with their own LDAP userid database and Kerberos services.
> 
> The common server is in its own realm and allows cross-realm
> authentication to the other university realms, using the origin realm
> to decide what namespace to map each user into.
> 
> If you are just doing read-only operations then you don't need any
> kind of namespace persistence on the NFS server's storage.  On the
> other hand, if you want to allow users to collaborate and create ACLs
> then you need something dramatically more involved.

Yeah, OK, I suppose I'd imagined mapping into the server's id space
somehow for that case, but I suppose this would be cleaner.  Still,
seems like a big pain....

> On the wire, the kerberos server would simply identify each NFSv4 ACL
> entry with a particular realm ID, but in the backend it would need
> some filesystem-level disambiguation (possibly the recently-proposed
> RichACL features?)

That doesn't help with owner and group.

--b.
