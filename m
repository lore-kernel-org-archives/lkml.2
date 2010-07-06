Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0GFXX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:23:58 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:36751 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755134Ab0GFXX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:23:56 -0400
Date: Wed, 7 Jul 2010 09:23:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100706232351.GD25018@dastard>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <871vbn2mk9.fsf@linux.vnet.ibm.com>
 <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eifgfsez.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 10:39:56PM +0530, Aneesh Kumar K. V wrote:
> On Tue, 6 Jul 2010 12:10:02 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Fri, Jul 02, 2010 at 02:45:45AM +0530, Aneesh Kumar K. V wrote:
> > > One use case i had was that if the userspace file server can directly
> > > work with the returned file system UUID,
> > 
> > I agree that the uuid should be split out from the rest of the
> > filehandle, but ...
> > 
> > > the it can build the file
> > > handle for client in a single call.
> > 
> > ... I don't understand why both need to come in the same system call.
> > Is it purely an efficiency question?  If so, why do you expect this to
> > be significant?
> 
> Since we know that system wide file handle should include a file system
> identifier and a file identifier my plan was to retrieve both in the
> same syscall.
> 
> 
> > 
> > (I would have thought that the system call overhead is so small, and so
> > many calls will already be required to perform the typical rpc, that
> > this would be insignificant.)
> > 
> > A filesystem uuid seems like a generally useful thing (maybe more so
> > than a filehandle), so it'd seem worth figuring out how to export that
> > separately.
> > 
> 
> I can add a new syscall that returns 
> 
> struct fs_uuid {
>        u8 fs_uuid[16];  
> };
> 
> long sys_get_fs_uuid(int dfd, char *name, struct fs_uuid *fsid, int flag);

libblkid already provides the UUID to userspace applications, doesn't it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
