Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab1GURKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:10:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:26356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab1GURKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,242,1309762800"; 
   d="scan'208";a="28614210"
Date: Thu, 21 Jul 2011 10:08:24 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: mingo@redhat.com, wzt <wzt.wzt@gmail.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        Michal Hocko <mhocko@suse.cz>,
        Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
Message-ID: <20110721170824.GA28974@tassilo.jf.intel.com>
References: <20110705062148.GA6056@program>
 <d1a1b6416d71a5062fb3b3e364f9db6b6d4ef6b2.1311258580.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1a1b6416d71a5062fb3b3e364f9db6b6d4ef6b2.1311258580.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 10:33:14AM -0400, Andy Lutomirski wrote:
> From: Zhitong Wang <wzt.wzt@gmail.com>
> 
> If init_vdso_vars ran out of memory (not very likely), then it would
> leak a few pages as well.
> 
> Also rename init_vdso_vars to just init_vdso, since initializing
> vvars is just about the only thing this function doesn't do.

Just add a GFP_PANIC, there's no way to recover from this.
Your system will not work without a vdso.

-Andi
