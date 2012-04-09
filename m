Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2DITg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:36:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:30982 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932118Ab2DITgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:36:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126975933"
Date: Mon, 9 Apr 2012 12:36:25 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][REGRESSION] panic: fix stack dump print on direct call
 to panic()
Message-ID: <20120409193625.GB28791@tassilo.jf.intel.com>
References: <1333992030-21181-1-git-send-email-jason.wessel@windriver.com>
 <4F832BC8.4090907@linux.intel.com>
 <4F8333BC.3050509@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8333BC.3050509@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is an interesting patch series, but I am not sure I agree about the caller propagating a flag to control what you see in panic.  I intentionally set CONFIG_DEBUG_VERBOSE=y for a reason, I want a stack trace if and when panic(), oops, BUG, etc... is ever called.  This might be a personal preference, but I do not wish to be searching on a string, to find out where the kernel execution terminated.  I want to see stack traces all the time, with the exception of the cases you pointed out in the original patch.

The idea was that callers who are calling panic not due to a programming
error (like no root, hardware error etc.) do not print the backtrace.
And only "assert like" panics would. 

This makes the screen less cluttered for user or hardware induced
panics.

Besides that it does a couple of related things, like set proper
timeouts.

-Andi
