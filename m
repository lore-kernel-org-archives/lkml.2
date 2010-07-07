Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0GGSFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 14:05:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:48303 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab0GGSFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 14:05:15 -0400
Date: Thu, 8 Jul 2010 04:05:07 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Neil Brown <neilb@suse.de>, hch@infradead.org, viro@zeniv.linux.org.uk,
       adilger@Sun.COM, corbet@lwn.net, serue@us.ibm.com,
       hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707180507.GE9263@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <871vbn2mk9.fsf@linux.vnet.ibm.com>
 <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
 <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com>
 <20100707150535.GB24360@fieldses.org>
 <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5920F408-E923-4467-A6A9-6C0923C00927@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:02:47AM -0600, Andreas Dilger wrote:
> On 2010-07-07, at 09:05, J. Bruce Fields wrote:
> > On Wed, Jul 07, 2010 at 01:40:53AM -0600, Andreas Dilger wrote:
> >> On 2010-07-06, at 11:09, Aneesh Kumar K. V wrote:
> >>> Since we know that system wide file handle should include a file system
> >>> identifier and a file identifier my plan was to retrieve both in the
> >>> same syscall.
> >> 
> >> Won't having it be in a separate system call be racy w.r.t. doing the pathname lookup twice?
> > 
> > It'll be rare that a server will want to *just* get a filehandle;
> > normally it will at least want to get some attributes at the same time.
> > So I think it will always need to open the file first and then do the
> > rest of the operations on the returned filehandle.
> 
> I think you are assuming too much about the use of the file handle.  What I'm interested in is not a userspace file server, but rather a more efficient way to have 10000's to millions of clients to be able to open the same regular file, without having to do full path traversal for each one.

Really? What kind of clients? What sort of speedups do you hope to see?
Path traversal can get vastly cheaper in both single threaded and parallel
cases with my locking changes.

It is not acceptable to work around fixable deficiencies in our critical
infrastructure like path walking with hacks like this. If path walking
is still much too expensive, that's another story...

