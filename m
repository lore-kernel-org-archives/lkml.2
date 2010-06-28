Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0F1ROs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:14:48 -0400
Received: from fn.samba.org ([216.83.154.106]:38044 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab0F1ROq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:14:46 -0400
Date: Mon, 28 Jun 2010 10:14:44 -0700
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Jeremy Allison <jra@samba.org>, David Howells <dhowells@redhat.com>,
       viro@zeniv.linux.org.uk, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Ext4: Make file creation time, i_version and
	i_generation available by xattrs
Message-ID: <20100628171444.GB9979@samba1>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20100628162626.6026.26679.stgit@warthog.procyon.org.uk> <AANLkTikkaRYyUfHILDCKYzXdLi9ORuQs05Rf9TScF_Tz@mail.gmail.com> <20100628164854.GA9979@samba1> <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilkfPkvyuQvN9zKrrY3DhJZ5iUfa5RXfErFwTiA@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 12:04:09PM -0500, Steve French wrote:
> On Mon, Jun 28, 2010 at 11:48 AM, Jeremy Allison <jra@samba.org> wrote:
> > On Mon, Jun 28, 2010 at 11:33:10AM -0500, Steve French wrote:
> >>
> >> It would be easy enough to do something similar for crtime for cifs
> >> (it may also be possible to do something similar to
> >> i_generation and i_version at least for smb2 but haven't
> >> experimented to see which servers could return something
> >> similar to version and generation).  I did have a request for
> >> someone doing a backup application over cifs to return creation
> >> time so at least this would make sense.
> >
> > We already have code in Samba to detect "birthtime"
> > (st_btime) as a returned member of a stat struct.
> >
> > This already works on many other platforms, so I'd
> > rather just have Linux stat fixed to work with
> > btime.
> 
> That sounds better but it hits the fs, vfs and libc
> and seems like libc is near impossible to get changes into.

It's a software project, it gets new features. This
is a new feature that is necessary to support new
file system features.

> Seems like in the short term adding xattrs is harmless, and
> doesn't hurt in the longrun

Yes it does. It's trying to do an end-run around
adding this into the entire stack where it'll be
useful for all applications. Samba releases live
forever. Do you want to be still maintaining the
"btime as xattr" stuff in 20 years ?

Fix it once, fix it right.

Jeremy.
