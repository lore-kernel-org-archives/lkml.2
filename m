Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1BHQun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:50:43 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37630 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab1BHQum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:50:42 -0500
Date: Tue, 8 Feb 2011 11:50:28 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slab tree
Message-ID: <20110208165028.GA9533@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20110131144246.dfa2abe3.sfr@canb.auug.org.au>
 <1296502339.30654.13.camel@jaguar>
 <alpine.DEB.2.00.1102030919380.6519@router.home>
 <alpine.DEB.2.00.1102080952490.13202@router.home>
 <alpine.DEB.2.00.1102080954330.13649@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102080954330.13649@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:55:48AM -0600, Christoph Lameter wrote:
> Argh. I accidentally sent an older version of the patch. This one is the
> tested one.
> 
> Subject: ext4: Remove use of kmem_cache_name
> 
> Remove the use of kmem_cache_name from ext4. In order to do that we need to
> strdup the name of the cache passed to kmem_cache_create.

There is a patch for this that Eric Sandeen has done which I've pushed
to Linus already.

Part of the problem is that some of the slab allocators call strdup,
and some don't.  So the only solution is to pass in a const,
statically allocated name.....

							- Ted
