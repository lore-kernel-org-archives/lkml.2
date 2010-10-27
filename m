Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0J0NhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:37:16 -0400
Received: from tundra.namei.org ([65.99.196.166]:36044 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab0J0NhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:37:14 -0400
Date: Thu, 28 Oct 2010 00:35:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        John Stoffel <john@stoffel.org>, Christoph Hellwig <hch@infradead.org>,
        "J.H." <warthog9@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, zohar@us.ibm.com, david@fromorbit.com,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
In-Reply-To: <20101026181310.GY19804@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.2.00.1010280016560.22962@tundra.namei.org>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com> <19653.55494.240658.165153@quad.stoffel.home> <4CC5DCBB.1070505@kernel.org> <AANLkTim5-QDaG3G_8hq3k83csWsdM-4Pt7V92WtmVx3i@mail.gmail.com> <20101025205746.GA6568@infradead.org>
 <AANLkTi=0Yag66SwgqhudZ8atU6LjaXmTX62VmQ+JMmhF@mail.gmail.com> <19654.57160.616600.480900@quad.stoffel.home> <AANLkTinywnaMNSABWTBwTmC5ML9BRTGgU0+YCfZJSkCT@mail.gmail.com> <20101026181310.GY19804@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010, Al Viro wrote:

> FWIW, I'm OK with that.  My general opinion about the quality and
> usefulness of security/* is a separate story, but if we are stuck
> with that shit in the tree, let's at least trim down what can be
> trimmed down.

If you have any specific concerns about code in security/ then please do 
explain them (in a different thread), so we can address them.

Note that if code is not being used, and/or has serious technical issues, 
it can be removed.  This already happened once with the BSD secure levels, 
which was basically unused, unmaintained, and had unfixable security 
issues -- it was taken out and shot.

Unfortunately, we have to deal with the fact that Unix was not designed 
with security primarily in mind, and that the security it does have is 
inherently flawed (all according to Ritchie c. 1970s).  We have to 
maintain decades of backward compatibility, address underlying flaws, and 
also address new forms of security threats which could not have even been 
imagined at the time.  We have to do all this without maybe using more 
than a few extra bytes in any major core data structure, and with nobody 
really agreeing on how to do it.

Expecting perfection out of this process is probably unreasonable, alas.



- James
-- 
James Morris
<jmorris@namei.org>
