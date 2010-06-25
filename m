Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0FYVqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:46:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab0FYVqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:46:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100625125306.7f9b1966@tlielax.poochiereds.net>
References: <20100625125306.7f9b1966@tlielax.poochiereds.net> <4C24A606.5040001@suse.de> <1277220214-3597-1-git-send-email-sjayaraman@suse.de> <yes> <9822.1277312573@redhat.com> <22697.1277470549@redhat.com>
To: Jeff Layton <jlayton@samba.org>
Cc: dhowells@redhat.com, Suresh Jayaraman <sjayaraman@suse.de>,
       Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and register them
Date: Fri, 25 Jun 2010 22:46:38 +0100
Message-ID: <18628.1277502398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@samba.org> wrote:

> Looks like it mostly uses the ctime. IMO, the mtime would be a better
> choice since it changes less frequently, but I don't guess that it
> matters very much.

I'd've thought mtime changes more frequently since that's altered when data is
written.  ctime is changed when attributes are changed.

Note that Ext4 appears to have a file creation time field in its inode
(struct ext4_inode::i_crtime[_extra]).  Can Samba be made to use that?

David
