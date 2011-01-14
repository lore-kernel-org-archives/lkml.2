Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1ANXqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:46:34 -0500
Received: from mx2.netapp.com ([216.240.18.37]:24604 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab1ANXqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:46:33 -0500
X-IronPort-AV: E=Sophos;i="4.60,325,1291622400"; 
   d="scan'208";a="505719549"
Subject: Re: NFS OOps  - kernel BUG at fs/nfs/nfs3xdr.c:1338
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Milan Broz <mbroz@redhat.com>,
        "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
In-Reply-To: <4D30D9D6.2080809@redhat.com>
References: <4D30D9D6.2080809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Fri, 14 Jan 2011 18:46:31 -0500
Message-ID: <1295048791.20016.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 14 Jan 2011 23:46:32.0660 (UTC) FILETIME=[45C6F140:01CBB445]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-15 at 00:18 +0100, Milan Broz wrote: 
> Hi,
> 
> on today Linus' tree I get OOps if using nfs.
> 
> server (2.6.36) exports dir:
> /dir   172.16.1.0/24(rw,async,all_squash,no_subtree_check,anonuid=500,anongid=500)
> 
> on client it is mounted  in fstab
> server:/dir  /mnt/tst  nfs  rw,soft 0 0
> 
> and these commands OOpses it (simplified from a configure script):
> 
> cd /dir
> touch x
> install x y
> 
> [  105.327701] ------------[ cut here ]------------
> [  105.327979] kernel BUG at fs/nfs/nfs3xdr.c:1338!

Chuck, why did you add those BUG_ON()s there? I know that
nfsacl_encode() is for some unfathomable reason declared as returning an
unsigned integer, but if you look at the actual code, you will see that
it returns a number of negative signed error values depending on whether
or not allocations succeeded, number of entries is valid, etc...

IOW: negative values are perfectly allowable here, and should simply
cause the rpc call to be aborted, not an Oops.

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

