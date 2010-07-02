Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab0GBQPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:15:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41434 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab0GBQPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:15:23 -0400
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle syscalls
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <andreas.dilger@oracle.com>
In-Reply-To: <20100702070548.GA6959@infradead.org>
Date: Fri, 2 Jul 2010 10:12:47 -0600
Cc: Neil Brown <neilb@suse.de>,
       "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "serue@us.ibm.com" <serue@us.ibm.com>,
       "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       "bfields@fieldses.org" <bfields@fieldses.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <BEEA47B4-4C9E-4086-96D2-FA6B8F68DA68@oracle.com>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <871vbn2mk9.fsf@linux.vnet.ibm.com> <20100702064108.64034561@notabene.brown> <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com> <20100702070548.GA6959@infradead.org>
To: hch@infradead.org
X-Mailer: Apple Mail (2.1078)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C2E1084.00C7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-02, at 01:05, hch@infradead.org wrote:
> On Thu, Jul 01, 2010 at 10:02:29PM -0600, Andreas Dilger wrote:
>> I'd like to be able to use this interface to implement the distributed open call proposed by the POSIX HECWG. This allows one client to do the path traversal, broadcast the file handle to the (maybe) 1M processes in the job via MPI, and then the other clients can open the file by handle without doing 1M times the full path traversal (which might be 10's of RPCs per process). 
> 
> The proposal is doomed anyway.  If we allow any sort of open by handle
> system call for unprivilegued users we need to do reconnect the dentry
> to the dcache path anyway (reconnect_path), which is more expensive than
> a normal path lookup.

I haven't looked at this part of the VFS in a while, but it looks like an implementation issue specific to knfsd, and shouldn't be needed for regular files.  i.e. if exportfs_encode_fh() is never used on a disconnected file, then this overhead is not incurred.

The above use of open_by_handle() is not for userspace NFS/Samba re-export, but to allow applications to open regular files for IO.  

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

