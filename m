Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0FYW04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 18:26:56 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:53425 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab0FYW0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 18:26:54 -0400
X-Authority-Analysis: v=1.0 c=1 a=iVNVO0OCT3kA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=20KFwNOVAAAA:8 a=hGzw-44bAAAA:8 a=AraS79FXNJ3kHilSTm4A:9 a=3STw0N-n4mJG0pydffwA:7 a=0uwppTlTaQ5HiYOalIavAxwTlvEA:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=dowx1zmaLagA:10
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Fri, 25 Jun 2010 18:26:51 -0400
From: Jeff Layton <jlayton@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
Message-ID: <20100625182651.36800d06@tlielax.poochiereds.net>
In-Reply-To: <18628.1277502398@redhat.com>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net>
	<4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>
	<yes>
	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>
	<18628.1277502398@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 22:46:38 +0100
David Howells <dhowells@redhat.com> wrote:

> Jeff Layton <jlayton@samba.org> wrote:
> 
> > Looks like it mostly uses the ctime. IMO, the mtime would be a better
> > choice since it changes less frequently, but I don't guess that it
> > matters very much.
> 
> I'd've thought mtime changes more frequently since that's altered when data is
> written.  ctime is changed when attributes are changed.
> 

IIUC, updating mtime for a write is also an attribute change, and that
affects ctime. According to the stat(2) manpage:

       The field st_ctime is changed by writing or by setting  inode  informa-
       tion (i.e., owner, group, link count, mode, etc.).

> Note that Ext4 appears to have a file creation time field in its inode
> (struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?
> 

Is it exposed to userspace in any (standard) way? It would be handy to
have that. While we're wishing...it might also be nice to have a
standard way to get at the i_generation from userspace too.

-- 
Jeff Layton <jlayton@samba.org>
