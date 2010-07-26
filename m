Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0GZQnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:43:08 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:13026
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754365Ab0GZQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:43:06 -0400
X-SpamScore: -10
X-BigFish: VPS-10(zz98dN936eMzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L66BR3-02-8JR-02
X-M-MSG: 
Date: Mon, 26 Jul 2010 18:42:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
Message-ID: <20100726164206.GJ26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
 <1279731838-1522-7-git-send-email-robert.richter@amd.com>
 <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
 <20100722123603.GU26154@erda.amd.com>
 <1279907405.2718.6.camel@sbs-t61>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1279907405.2718.6.camel@sbs-t61>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.10 13:50:05, Suresh Siddha wrote:

> Then the more appropriate place for this is to check at the beginning of
> the xsave init code.

No it isn't, HAVE_HWFP is an fpu implementation and the soft fpu check
would be duplicate in xsave.c. Also, the HAVE_HWFP macro is local in
i387.c and would have to be exported in a header file then, which
somehow taints the api.

So I rather tend to this patch than implementing fpu code in xsave for
a small or no benefit.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

