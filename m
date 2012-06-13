Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2FMVvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:51:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:15166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab2FMVvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157291395"
Date: Wed, 13 Jun 2012 14:51:22 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120613215122.GF32604@tassilo.jf.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
 <1339623321.8980.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339623321.8980.66.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This would really much better live in common code where it can be
> preemptible in some sites. There really is no need for this to be
> non-preemptible.

Okay I can look. But you're really optimizing the wrong things here.
Even on a 4096 CPU system such a loop is miniscule compared to the
actual cost of the microcode update, which stops the complete CPU
for quite some time.

Basically microcode updates and low latency are incompatible
Don't do it when it hurts.

Unfortunately i'm changing all the callers two patches further,
so it'll be messy too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
