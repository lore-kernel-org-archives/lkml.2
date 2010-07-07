Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab0GGPFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:05:52 -0400
Received: from fieldses.org ([174.143.236.118]:44307 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0GGPFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:05:51 -0400
Date: Wed, 7 Jul 2010 11:05:36 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Andreas Dilger <andreas.dilger@oracle.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
       Neil Brown <neilb@suse.de>, hch@infradead.org, viro@zeniv.linux.org.uk,
       adilger@sun.com, corbet@lwn.net, serue@us.ibm.com,
       hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 0/11] Generic name to handle and open by handle
 syscalls
Message-ID: <20100707150535.GB24360@fieldses.org>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <871vbn2mk9.fsf@linux.vnet.ibm.com>
 <20100702064108.64034561@notabene.brown>
 <87iq4y29a6.fsf@linux.vnet.ibm.com>
 <20100706161002.GD7387@fieldses.org>
 <87eifgfsez.fsf@linux.vnet.ibm.com>
 <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2DC68584-15A8-4C48-8E65-E7EF1DCEEAD0@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 01:40:53AM -0600, Andreas Dilger wrote:
> On 2010-07-06, at 11:09, Aneesh Kumar K. V wrote:
> > On Tue, 6 Jul 2010 12:10:02 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> >> ... I don't understand why both need to come in the same system call.
> >> Is it purely an efficiency question?  If so, why do you expect this to
> >> be significant?
> > 
> > Since we know that system wide file handle should include a file system
> > identifier and a file identifier my plan was to retrieve both in the
> > same syscall.
> 
> Won't having it be in a separate system call be racy w.r.t. doing the pathname lookup twice?

It'll be rare that a server will want to *just* get a filehandle;
normally it will at least want to get some attributes at the same time.

So I think it will always need to open the file first and then do the
rest of the operations on the returned filehandle.

--b.
