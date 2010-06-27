Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0F0SRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 14:17:46 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52430 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0F0SRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 14:17:41 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mingming Cao <mcao@us.ibm.com>, Steve French <smfrench@gmail.com>,
       "DENIEL Philippe" <philippe.deniel@cea.fr>
Cc: David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
       Jeff Layton <jlayton@samba.org>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, Suresh Jayaraman <sjayaraman@suse.de>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
In-Reply-To: <OFB55E8EC7.E8DD23D5-ON8725774E.0004921E-8825774E.0004CC31@us.ibm.com>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net> <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <9822.1277312573@redhat.com> <22697.1277470549@redhat.com> <18628.1277502398@redhat.com> <20100625182651.36800d06@tlielax.poochiereds.net> <AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com> <OFB55E8EC7.E8DD23D5-ON8725774E.0004921E-8825774E.0004CC31@us.ibm.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sun, 27 Jun 2010 23:47:21 +0530
Message-ID: <871vbscpce.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 17:52:24 -0700, Mingming Cao <mcao@us.ibm.com> wrote:
> 
> 
> Steve French <smfrench@gmail.com> wrote on 06/25/2010 04:05:30 PM:
> 
> > Steve French <smfrench@gmail.com>
> > 06/25/2010 04:05 PM
> >
> > To
> >
> > Jeff Layton <jlayton@samba.org>, "Aneesh Kumar K.V"
> > <aneesh.kumar@linux.vnet.ibm.com>, Mingming Cao/Beaverton/IBM@IBMUS
> >
> > cc
> >
> > David Howells <dhowells@redhat.com>, Suresh Jayaraman
> > <sjayaraman@suse.de>, linux-cifs@vger.kernel.org, linux-
> > fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, samba-
> > technical@lists.samba.org, Jeff Layton <jlayton@redhat.com>
> >
> > Subject
> >
> > Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
> > register them
> >
> > On Fri, Jun 25, 2010 at 5:26 PM, Jeff Layton <jlayton@samba.org> wrote:
> > >
> > > On Fri, 25 Jun 2010 22:46:38 +0100
> > > David Howells <dhowells@redhat.com> wrote:
> > >
> > > > Jeff Layton <jlayton@samba.org> wrote:
> > > >
> > > > > Looks like it mostly uses the ctime. IMO, the mtime would be a
> better
> > > > > choice since it changes less frequently, but I don't guess that it
> > > > > matters very much.
> > > >
> > > > I'd've thought mtime changes more frequently since that's
> > altered when data is
> > > > written.  ctime is changed when attributes are changed.
> > > >
> > >
> > > IIUC, updating mtime for a write is also an attribute change, and that
> > > affects ctime. According to the stat(2) manpage:
> > >
> > >       The field st_ctime is changed by writing or by setting
> >  inode  informa-
> > >       tion (i.e., owner, group, link count, mode, etc.).
> > >
> > > > Note that Ext4 appears to have a file creation time field in its
> inode
> > > > (struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use
> that?
> > > >
> > >
> > > Is it exposed to userspace in any (standard) way? It would be handy to
> > > have that. While we're wishing...it might also be nice to have a
> > > standard way to get at the i_generation from userspace too.
> > >
> >
> > Yes - I have talked with MingMing and Aneesh about those (NFS may
> > someday be able to use those too).  An obstacle in the past had been
> > that samba server stores its own fake creation time in an ndr encoded
> > xattr which complicates things.
> >
> > MingMing/Annesh -
> > Xattr or other way to get at birth time?
> >
> >
> 
> Not yet,
>  The ext4 file creation time only accesable from the kernel at the moment.
> There were discussion
> to make this information avaliable via xattr before, but was rejected,
> since most people
> agree that making this info avalibele via stat() is more standard. However
> modifying stat() would imply
> big interface change. thus no action has been taken yet.

NFS ganesha pNFS also had a requirement for getting i_generation and
inode number in userspace. So may be we should now look at updating
stat or add a variant syscall that include i_generation and create time
in the return value

-aneesh
