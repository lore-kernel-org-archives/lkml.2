Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0IOLVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:21:55 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:52168 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab0IOLVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:21:54 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 07:21:54 EDT
X-AuditID: 1209190e-b7b91ae0000068d0-2b-4c90ab29df1b
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
Date: Wed, 15 Sep 2010 07:16:46 -0400
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com> <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com> <4C8FE263.5070101@kernel.org> <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com>
To: David Rientjes <rientjes@google.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 14, 2010, at 8:02 PM, David Rientjes wrote:

> 
> I don't believe that we need to remove cache merging and allocate more 
> memory by default to be able to identify a particular cache using an 
> egregious amount of slab when troubleshooting a problem.  

Why not keep a separate accounting for each cache, even if we use the same set of pages for a set of slab cache?   It is *really* *useful* to be able to get that kind of debugging information without needing to reboot the system into some kind of magic debugging mode.  More than once I've had to debug a customer system where there was some kind of memory allocation problem, where rebooting wouldn't have been an option, or where rebooting would have destroyed the evidence.

It would seem to me that if there was a "super-slab" pointer in the slab cache structure, then if it turns out the slab system wants to merge a new slab cache with an existing one, you could instead allocate a "super slab" structure, copy information from the initial slab cache into the "super slab" and then set a pointer to the "super slab".   The only information that would be kept in the individual slab cache structures that have a non-zero "super slab" pointer would be the number of objects allocator for that particular object time.

This allows for us to track object class usage without needing to waste space caused by partially filled slab pages.   I think this would be a real win....

-- Ted

