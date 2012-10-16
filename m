Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2JPQLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:11:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:15353 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab2JPQLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:11:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="205134093"
Message-ID: <507D8712.4050008@zytor.com>
Date: Tue, 16 Oct 2012 09:10:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        greg@kroah.com, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        mpm@selenic.com, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        tglx@linutronix.de, davem@davemloft.net, mingo@kernel.org,
        DJ Johnston <dj.johnston@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC] random: Account for entropy loss due to overwrites
References: <1344878779-10700-1-git-send-email-hpa@linux.intel.com> <50675038.9000108@zytor.com> <20121016040848.GE17446@thunk.org> <507CE663.2060502@linux.intel.com> <20121016155307.GF17446@thunk.org>
In-Reply-To: <20121016155307.GF17446@thunk.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 08:53 AM, Theodore Ts'o wrote:
> 
> ... and it looks like include/linux/log2.h already has a definition
> for ilog2() which should definitely work for all versions of gcc, so
> we could do this instead:
> 
> #define shiftbits(w)	(ilog2((w)) + 5)
> 
> 	/* x^128 + x^103 + x^76 + x^51 +x^25 + x + 1 -- 105 */
> 	{ shiftbits(128), 103,	76,	51,	25,	1 },
> 	/* x^32 + x^26 + x^20 + x^14 + x^7 + x + 1 -- 15 */
> 	{ shiftbits(32),  26,	20,	14,	7,	1 },
> 

OK, works for me.  I'll rev the patch later this week.

	-hpa


