Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0GBHGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:06:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GBHGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:06:01 -0400
Date: Fri, 2 Jul 2010 03:05:48 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: Neil Brown <neilb@suse.de>,
       "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       "hch@infradead.org" <hch@infradead.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "adilger@sun.com" <adilger@sun.com>, "corbet@lwn.net" <corbet@lwn.net>,
       "serue@us.ibm.com" <serue@us.ibm.com>,
       "hooanon05@yahoo.co.jp" <hooanon05@yahoo.co.jp>,
       "bfields@fieldses.org" <bfields@fieldses.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "sfrench@us.ibm.com" <sfrench@us.ibm.com>,
       "philippe.deniel@CEA.FR" <philippe.deniel@CEA.FR>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100702070548.GA6959@infradead.org>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <871vbn2mk9.fsf@linux.vnet.ibm.com>
 <20100702064108.64034561@notabene.brown>
 <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A44260DA-245D-47DD-820E-2F4F1F50BB9D@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:02:29PM -0600, Andreas Dilger wrote:
> I'd like to be able to use this interface to implement the distributed open call proposed by the POSIX HECWG. This allows one client to do the path traversal, broadcast the file handle to the (maybe) 1M processes in the job via MPI, and then the other clients can open the file by handle without doing 1M times the full path traversal (which might be 10's of RPCs per process). 

The proposal is doomed anyway.  If we allow any sort of open by handle
system call for unprivilegued users we need to do reconnect the dentry
to the dcache path anyway (reconnect_path), which is more expensive than
a normal path lookup.

