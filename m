Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0F2UlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:41:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0F2UlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:41:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7@mail.gmail.com>
References: <AANLkTimIh9ZAasPnN5xxGxbupwkct7UihHcMe26r-MD7@mail.gmail.com> <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/3] Extended file stat functions
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jun 2010 21:41:01 +0100
Message-ID: <23973.1277844061@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> How does a fs return an "unknown" value for one
> (e.g. version field) ... 0  or -1  or ...

Well, for the new creation time, inode version and data version fields, the
query_flags field has a bit for each that's set if the field contains a value,
and is clear if it doesn't.

See the test program on patch 3.

> One hole that this reminded me about is how to return the superblock
> time granularity (for NFSv4 this is attribute 51 "time_delta" which
> is called on a superblock not on a file).  We run into time rounding
> issues with Samba too.

That sounds like something that should be accessible through statfs.  But it
could be made accessible here too.  It would also apply to FAT, which I
believe has a 2s granularity.

> >  (4) Should the inode number and data version number fields be 128-bit?
> This is tricky for SMB2, if you can also provide a device id (or an object
> id of some sort for the superblock) then 64 bit inode number is ok.

A remote device ID?  That would be possible.  That could be used by AFS to
return the numeric volume ID (32 bits) and by NFS to return the FSID (128
bits).  Would you be using the VolumeGUID (128 bits) for SMB2?


David
