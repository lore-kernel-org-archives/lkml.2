Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749Ab0GDDWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 23:22:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33740 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0GDDWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 23:22:39 -0400
Date: Sat, 3 Jul 2010 21:22:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Break out types from <linux/list.h> to
	<linux/list_types.h>.
Message-ID: <20100704032237.GD5842@parisc-linux.org>
References: <201007021811.04197.arnd@arndb.de> <4C2E3F1F.3010202@tilera.com> <20100702204817.GB5842@parisc-linux.org> <201007031100.43158.arnd@arndb.de> <4C2FE84E.4010407@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2FE84E.4010407@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 09:47:58PM -0400, Chris Metcalf wrote:
> Sounds like we have a consensus on moving the list_head, hlist_head, and
> hlist_node types to <linux/types.h>.  I assume everyone is agreed that
> initializers, etc., should stay in <linux/list.h>.  I will send out a
> revised git patch on Sunday.

Yes, I think that's reasonable.  By way of comparison, ATOMIC_INIT,
etc. stayed in atomic.h.  It makes sense -- you only need the types
for structure definitions, you don't need the initialisers.

I suppose if you have a header which defines an initialiser like sched.h
does, you'll want the list.h initialisers, but anything that complex
should be able to handle including the full list.h header.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
