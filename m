Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1GQLDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 07:03:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38990 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1GQLDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 07:03:14 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Shan Hai <haishan.bai@gmail.com>, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1310860194.25044.17.camel@pasglop>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Jul 2011 13:02:41 +0200
Message-ID: <1310900561.13765.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 09:49 +1000, Benjamin Herrenschmidt wrote:
> In the meantime, other than rewriting the futex code to not require
> those in-atomic accesses (can't it just access the pages via the linear
> mapping and/or kmap after the gup ?),

That'll wreck performance on things like ARM and SPARC that have to deal
with cache aliasing.

>  all I see would be a way to force
> dirty and young after gup, with appropriate locks, or a variant of gup
> (via a flag ?) to require it to do so. 

Again, _WHY_ isn't gup(.write=1) a complete write fault? Its supposed to
be, it needs to break COW, do dirty page tracking and call page_mkwrite.
I'm still thinking this e500 stuff is smoking crack.

ARM has no hardware dirty bit either, and yet it works for them. I can't
exactly tell how because I got lost in there, but it does, again,
suggest e500 is on crack.
