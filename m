Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0GGRDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0GGRDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:03:07 -0400
Date: Thu, 8 Jul 2010 03:03:03 +1000
From: Nick Piggin <npiggin@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       bfields@fieldses.org, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V14 05/11] vfs: Support null pathname in readlink
Message-ID: <20100707170303.GD9263@laptop>
References: <1276621981-2774-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1276621981-2774-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100707152706.GT11732@laptop>
 <87aaq3fe2b.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aaq3fe2b.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 10:02:12PM +0530, Aneesh Kumar K. V wrote:
> On Thu, 8 Jul 2010 01:27:06 +1000, Nick Piggin <npiggin@suse.de> wrote:
> > This (and all the others) is really ugly overloading of syscall
> > arguments IMO, and the changelog is seriously lacking for such
> > changes.
> 
> Initially we had  freadlink
> 
> http://lkml.org/lkml/2010/5/12/222
> 
> We updated the patches to use the existing readlinkat interface because
> utimensat(2) already exposed a similar interface. So it should be ok to
> expect that other *at call behaved in a similar way ?

I'm not sure whether it's OK or not. Probably is, it is a slight API
change though, that should at least be noted in the changelog.


> > This also changes the the syscall API of existing calls; from reading
> > the path at NULL, to switching to a completely different syscall.
> > Perhaps you're assuming nobody relies on SIGSEGV / mmapped NULL address
> > there, but even then you surely need to document the changed semantics
> > somewhere (and document the new syscall semantics properly).
> 
> 
> Yes this would need a documentation update. But i guess since we already
> have utimensat(2) behaving similarly we are ok to extent readlinkat,
> linkat and faccessat on similar lines ?

At least there is precedent. Pretty ugly though :( Well if others
(Christoph and Al, primarily) think it's OK then fine by me. But
please put comments or changelog for API changes such that a man page
writer could easily update it.


