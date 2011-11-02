Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1KBNtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 09:49:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36174 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab1KBNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 09:49:07 -0400
Date: Wed, 2 Nov 2011 14:49:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: REGRESSION: "perf: Add PM notifiers ..." breaks resume
Message-ID: <20111102134900.GB4377@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resume stopped working on my Acer Aspire 1830T post 3.1. The screen
just stays black after wakeup.

I bisected it down to 

commit 144060fee07e9c22e179d00819c83c86fbcbf82c
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Aug 1 12:49:14 2011 +0200

    perf: Add PM notifiers to fix CPU hotplug races
    
Reverting this patch fixes the problem for me.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
