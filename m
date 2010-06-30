Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0F3Jry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab0F3Jrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:47:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F@dilger.ca>
References: <CE3451EE-F8B2-47EF-AC1C-4EEEBE68B30F@dilger.ca> <20100630011656.18960.4255.stgit@warthog.procyon.org.uk> <20100630011712.18960.3723.stgit@warthog.procyon.org.uk> <1277862536.9326.3.camel@heimdal.trondhjem.org>
To: Andreas Dilger <adilger@dilger.ca>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 10:47:26 +0100
Message-ID: <29130.1277891246@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Dilger <adilger@dilger.ca> wrote:

> > Yes, but could we please also add a flag that allows you to specify that
> > the kernel _must_ provide up to date attributes.
> 
> To my reading, if the query_flags are set in the input buffer, then the
> attributes MUST be fetched.  If they are unset, then they MAY be fetched,
> and the corresponding query_flags will be set in the return buffer.  If the
> query_flags are not set in the return buffer then I assume the output values
> are undefined.

I think Trond may have a point, looking at nfs_getattr().

There can be three levels:

 (1) Don't check with the server, just go with what we've got in the cache if
     it's available.  Results returned may be approximate.

 (2) Check with the server if the cached attributes are out of date or if
     something is requested that we don't keep in RAM.

 (3) Check with the server anyway.

David
