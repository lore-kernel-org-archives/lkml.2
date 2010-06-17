Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629Ab0FQSRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:17:20 -0400
Received: from emroute3.ornl.gov ([160.91.4.110]:39102 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760601Ab0FQSRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:17:19 -0400
Date: Thu, 17 Jun 2010 14:17:17 -0400
From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH v2] d_ino considered harmful
In-reply-to: <30568.1276797848@jrobl>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Valerie Aurora <vaurora@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       Andreas Dilger <adilger@sun.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-id: <1276798637.2492.8.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
References: <20100616185913.GA15566@shell> <20100616195359.GA24382@shell>
 <1276721084.13788.53.camel@lap75545.ornl.gov> <30568.1276797848@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 14:04 -0400, J. R. Okajima wrote:
> David Dillow:
> > For example, our main Lustre scratch space has over 285 million files in
> > it, and using find -inum takes over 72 hours to walk the tree using
> 	:::
> > Using ne2scan -- which uses libext2fs and combines the inode scan and
> > the name lookup -- takes over 48 hours to generate a list of candidate
> > files for the purge example. With an optimized inode scan and the custom
> 	:::
> 
> While I've never heard of ne2scan, I am interested in this simplified
> problem such as "find the pathname(s) from an inum in a huge fs."
> Is ne2scan essentially equivalent to "debugfs ncheck inum"?

Yes, except it does that for every live inode in the system. ne2scan is
extended for use on Lustre's backing store -- it parses the LOV object
map and displays the information -- so I'm not sure how usable it will
be on an plain ext{2,3,4} file system. It is based off of e2scan in the
Oracle (nee Sun) Lustre version of e2fsprogs, so that could be a
starting point for you.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


