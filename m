Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0G0Ix7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:53:59 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:36995 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801Ab0G0Ix5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:53:57 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L67KPQ-01-AH8-02
X-M-MSG: 
Date: Tue, 27 Jul 2010 10:53:50 +0200
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
Message-ID: <20100727085350.GM26154@erda.amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
 <1279731838-1522-7-git-send-email-robert.richter@amd.com>
 <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
 <20100722123603.GU26154@erda.amd.com>
 <4C4DD35C.8060708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C4DD35C.8060708@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.10 14:26:36, H. Peter Anvin wrote:

> >> I think it is cleaner to clear these cpu capabilities in the function
> >> which handles no387 boot parameter.
> > 
> > This does not cover all (of course weird but potentially existing)
> > cases. Disabling xsave in the no387 setup would only work if an fpu
> > exists.
> 
> If the fpu doesn't exist, then xsave can't exist, either.

It does not convince me to move it either to no387 setup or
xsave_init(). There is no benefit with both of it. We should disable
it where we decide to use the soft fpu. Otherwise we will not have the
same underlying rules for it. In case of xsave_init() we need to
duplicate fpu code and export it to xsave code. I want to avoid this
as xsave and fpu code should be kept simple and only be shared where
necessary.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

