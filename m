Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2KXNNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 08:13:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2KXNNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 08:13:20 -0500
Date: Sat, 24 Nov 2012 13:13:16 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] balancenuma: fix page locking in migrating thp
Message-ID: <20121124131316.GC8218@suse.de>
References: <CAJd=RBCOCnzM0SbUPeCOe=cLfuJ5doFKWnCk5uSZhkJXbSArHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBCOCnzM0SbUPeCOe=cLfuJ5doFKWnCk5uSZhkJXbSArHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 12:27:39PM +0800, Hillf Danton wrote:
> If fail to migrate thp(due to unsuccessful isolation), and if the original
> pmd entry is changed after reaquiring page table lock, it is unsafe to
> release the page lock as page maybe unstable.
> 
> It is fixed by raising extra page count before trying migration.
> 

Less sure of this one but the locking here is a mess. A reference count
is already taken. Isolating the page takes another reference count so the
first one can be dropped without the page being freed underneath us. The
migration function takes care of unlocking the page on a successful
migration. On unsuccessful migration, the PMD is rechecked under the
lock before clearing the pmd_numa. I'm not sure where you are seeing
the instability but I haven't fired up my brain either (it's the weekend
:)). I'll take a fresh look at this Monday.

Thanks!

-- 
Mel Gorman
SUSE Labs
