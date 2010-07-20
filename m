Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0GTPXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:23:48 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60974 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab0GTPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:23:47 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: sfrench@us.ibm.com, ffilz@us.ibm.com, adilger@sun.com, sandeen@redhat.com,
        tytso@mit.edu, bfields@citi.umich.edu, jlayton@redhat.com,
        linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V2 00/16]  New ACL format for better NFSv4 acl interoperability
In-Reply-To: <201007201211.53289.agruen@suse.de>
References: <1278096227-16784-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <201007192119.50868.agruen@suse.de> <m34ofucxes.fsf@linux.vnet.ibm.com> <201007201211.53289.agruen@suse.de>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 20 Jul 2010 20:53:36 +0530
Message-ID: <m3y6d6b2iv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 12:11:53 +0200, Andreas Gruenbacher <agruen@suse.de> wrote:
> On Tuesday 20 July 2010 11:31:07 Aneesh Kumar K. V wrote:
> > We need to update ACL4_VALID_FLAGS to now consider ACL4_MASKED as a
> > valid flag.  This is also needed for userspace.
> 
> Good point, I missed that.

I updated the patch and will push the change to korg after running some
test.

> 
> > On a related note, should we move ACL4_MASKED and ACL4_POSIX_MAPPED to
> > be the higher bits ? That would make sure we will be able to accomodate
> > new flag value NFSv4 define.
> 
> That makes sense, except that ACL4_POSIX_MAPPED hasn't entered the scene in 
> the patches posted here, and I'm still not convinced that we'll actually need 
> it.
> 

The userspace change did result in a different output for the below ex:

richacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f

this now gives

/mnt/d# richacl  --get --numeric  f
f:
 flags:a
   101:-w-----------::deny
   101:rw-----------::allow
   101:-w-----------:a:deny
   101:rw-----------:a:allow

that 'w' in rw::allow is redundant, because we have a deny entry before.

-aneesh
