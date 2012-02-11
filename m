Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2BKQSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 11:18:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:63432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab2BKQSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 11:18:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124172548"
From: Andi Kleen <andi@firstfloor.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Anton Altaparmakov <anton@tuxera.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>,
        Janne Kalliom?ki <janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Direct i/o changes break all non-GPL file systems
References: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
	<20120208001519.501b6fea@pyramind.ukuu.org.uk>
	<673AFC57-2B73-49AC-962E-CAB1DE775B2C@tuxera.com>
	<D35F212C-0C17-43CE-885D-62C6DF58E2C2@dilger.ca>
	<CA+55aFyBAiZ3khqQiSU0OBafMABsAzdU5DLzZvaM_Et52Wte5w@mail.gmail.com>
	<20120210211946.GJ23916@ZenIV.linux.org.uk>
Date: Sat, 11 Feb 2012 08:18:44 -0800
In-Reply-To: <20120210211946.GJ23916@ZenIV.linux.org.uk> (Al Viro's message of
	"Fri, 10 Feb 2012 21:19:48 +0000")
Message-ID: <m2mx8p738b.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> and should not be used by any modules; don't export it at all
> 	3) it's a layering violation that unfortunately still is needed for
> an in-tree module.  The *only* case where I'd consider EXPORT_SYMBOL_GPL
> borderline useful, as a bad proxy for EXPORT_SYMBOL_DONT_USE_OUT_OF_TREE.

I had the namespace patches to make this explicit some time ago

http://lwn.net/Articles/259839/

This allows to export specific symbols only for special other modules,
in case it's only a single module that needs a "backdoor"

I can look at resubmitting the patchkit.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
