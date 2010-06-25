Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0FYXFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:05:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51369 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0FYXFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B+7qQvdOpN5a/KCRrDbssKZX8D3SnP73VMHd9RpkqP9nCHCmSLAgbeH03+/m6CLVAo
         G+NKWqWtknwPBkYqT/bdP2XEak1yr+0rjOqjUaNvaT7AhzsyHEJBkaNnsbS3qaRy39OP
         S7OkAyHfmgdeNAHkKnKRF73hfpvgAqR9X4bn8=
MIME-Version: 1.0
In-Reply-To: <20100625182651.36800d06@tlielax.poochiereds.net>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>
	<4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>
	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>
	<18628.1277502398@redhat.com>
	<20100625182651.36800d06@tlielax.poochiereds.net>
Date: Fri, 25 Jun 2010 18:05:30 -0500
Message-ID: <AANLkTilOTrHLvLv4XWYZO6xCnYZgYT7gO2M-oKZ6VvqM@mail.gmail.com>
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and 
	register them
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Mingming Cao <mcao@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Suresh Jayaraman <sjayaraman@suse.de>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 5:26 PM, Jeff Layton <jlayton@samba.org> wrote:
>
> On Fri, 25 Jun 2010 22:46:38 +0100
> David Howells <dhowells@redhat.com> wrote:
>
> > Jeff Layton <jlayton@samba.org> wrote:
> >
> > > Looks like it mostly uses the ctime. IMO, the mtime would be a better
> > > choice since it changes less frequently, but I don't guess that it
> > > matters very much.
> >
> > I'd've thought mtime changes more frequently since that's altered when data is
> > written.  ctime is changed when attributes are changed.
> >
>
> IIUC, updating mtime for a write is also an attribute change, and that
> affects ctime. According to the stat(2) manpage:
>
>       The field st_ctime is changed by writing or by setting  inode  informa-
>       tion (i.e., owner, group, link count, mode, etc.).
>
> > Note that Ext4 appears to have a file creation time field in its inode
> > (struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?
> >
>
> Is it exposed to userspace in any (standard) way? It would be handy to
> have that. While we're wishing...it might also be nice to have a
> standard way to get at the i_generation from userspace too.
>

Yes - I have talked with MingMing and Aneesh about those (NFS may
someday be able to use those too).  An obstacle in the past had been
that samba server stores its own fake creation time in an ndr encoded
xattr which complicates things.

MingMing/Annesh -
Xattr or other way to get at birth time?


--
Thanks,

Steve
