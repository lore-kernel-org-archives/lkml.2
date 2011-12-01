Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1LAMee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:34:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:34673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab1LAMed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:34:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,277,1320652800"; 
   d="scan'208";a="81060637"
Date: Thu, 1 Dec 2011 20:24:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: Make write(2) interruptible by a fatal signal
Message-ID: <20111201122425.GA16274@localhost>
References: <1322735278-17420-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322735278-17420-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How are we going to do with this patch?

> This patch makes write interruptible by SIGKILL.

Let me try to summarize the objective impacts of (not) merging this
patch, and would like to hear more opinions from experienced users.

- w/o patch

BEHAVIOR:
write(2) insists to complete even when the user really wants to stop it.

IMPACT:
It could be annoying to experience slow responses to "kill -9" when
it's a large write to a slow device, for example,

        dd if=/dev/zero of=/mnt/nokia/zero bs=100M

- w/ patch

BEHAVIOR:
write(2) aborts quickly with possible partial write on SIGKILL

IMPACT:
The partial write might lead to data corruption somewhere, sometime
(the possibility is low but real) and bring trouble to some users.

Thanks,
Fengguang
