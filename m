Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1BXVxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:53:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:20209 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1BXVxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:53:11 -0500
MIME-Version: 1.0
Message-ID: <b787274a-de5f-4a0d-957e-d5a9c2f2d752@default>
Date: Thu, 24 Feb 2011 13:51:03 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: RE: encode_fh: have inode but no dentry
References: <c4d12fe2-2175-4d59-9ef2-e6d5996023f0@default
 20110224212317.GD22723@ZenIV.linux.org.uk>
In-Reply-To: <20110224212317.GD22723@ZenIV.linux.org.uk>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D66D344.007C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Al Viro [mailto:viro@ZenIV.linux.org.uk]
> Subject: Re: encode_fh: have inode but no dentry
> 
> On Thu, Feb 24, 2011 at 01:16:34PM -0800, Dan Magenheimer wrote:
> > Hi Aneesh --
> >
> > I see you are continuing with encode_fh related
> > development so I thought I would bring this up
> > with you.
> >
> > I have a need to call the encode_fh op in a
> > situation where I have an inode but not a dentry,
> > and calling d_find_alias(inode) sometimes returns
> > NULL.  In my usage, connectable is always zero, so
> > having just the inode should be sufficient to get
> > useful results from encode_fh, at least for the
> > filesystems I've looked at.
> 
> [snip]
> 
> > Such a change would require a patch that touched
> > nearly every filesystem so it's clearly not to
> > be taken lightly.
> >
> > Any thoughts on this?
> 
> How about "tell us what do you need that for", for starters?

(Wow, that was fast! /me pictures a 64-core Al Viro
parallelizing incoming lkml email.)

It's for some work I'm building on top of cleancache.
Since cleancache isn't merged (yet), it's not pressing,
but this seemed a reasonable approach so, before I
started looking at more complicated alternatives,
I thought I'd get some idea if this is feasible or not.

The situation arises when the inode is in cache but
the dentry is not, but I still need a filehandle.
In the non-connectable case, this should still be OK.
Seems like a case that might be more broadly useful.

Thanks,
Dan
