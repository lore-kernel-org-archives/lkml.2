Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab1GOHyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 03:54:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:55310 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964863Ab1GOHyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 03:54:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,534,1304319600"; 
   d="scan'208";a="27976986"
From: Andi Kleen <andi@firstfloor.org>
To: Anton Blanchard <anton@samba.org>
Cc: dwg@au1.ibm.com, mel@csn.ul.ie, akpm@linux-foundation.org,
        hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugepage: Allow parallelization of the hugepage fault path
References: <20110125143226.37532ea2@kryten> <20110125143414.1dbb150c@kryten>
Date: Fri, 15 Jul 2011 00:52:38 -0700
In-Reply-To: <20110125143414.1dbb150c@kryten> (Anton Blanchard's message of
	"Tue, 25 Jan 2011 14:34:14 +1100")
Message-ID: <m2zkkg6kvs.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:


> This patch improves the situation by replacing the single mutex with a
> table of mutexes, selected based on a hash of the address_space and
> file offset being faulted (or mm and virtual address for MAP_PRIVATE
> mappings).

It's unclear to me how this solves the original OOM problem.
But then you can still have early oom over all the hugepages if they
happen to hash to different pages, can't you? 

I think it would be better to move out the clearing out of the lock,
and possibly take the lock only when the hugepages are about to 
go OOM.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
