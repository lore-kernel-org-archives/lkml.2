Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1IPRyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:54:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:39125 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1IPRyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,394,1312182000"; 
   d="scan'208";a="17888498"
From: Andi Kleen <andi@firstfloor.org>
To: djwong@us.ibm.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] ext4: Prevent stack overrun in ext4_file_open when recording last known mountpoint
References: <20110915231645.GE12086@tux1.beaverton.ibm.com>
Date: Fri, 16 Sep 2011 10:54:35 -0700
In-Reply-To: <20110915231645.GE12086@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Thu, 15 Sep 2011 16:16:45 -0700")
Message-ID: <m239fwfk4k.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> writes:


> Writing stack variables into the superblock doesn't sound like a great idea, so
> use strncpy instead.

This means you can end up with a non 0 terminated path in the
superblock, which could confuse programs.

Better use strlcpy()

strncpy is usually a bad idea, it's semantics overall are quite
bogus and it's also inefficient because it always fills.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
