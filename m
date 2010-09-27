Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390Ab0I0Nn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:43:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:3628 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0I0Nnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:43:55 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L9ERGS-01-DDJ-02
X-M-MSG: 
Date: Mon, 27 Sep 2010 15:43:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: huang ying <huang.ying.caritas@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 7/7] x86, NMI, Remove do_nmi_callback logic
Message-ID: <20100927134341.GQ13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-7-git-send-email-ying.huang@intel.com>
 <20100927104426.GD32222@erda.amd.com>
 <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <AANLkTinA2HK57w5wqCtq319WNy-PLtWaGBe-v+uoFB=Y@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 08:56:44, huang ying wrote:

> >> -static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
> >> -{
> >> -     unsigned char reason = get_nmi_reason();
> >> -     char buf[64];
> >> -
> >> -     sprintf(buf, "NMI received for unknown reason %02x\n", reason);
> >> -     die_nmi(buf, regs, 1); /* Always panic here */
> >> -     return 0;
> >
> > You are dropping this code that is different to panic().
> 
> What is the difference? Is it relevant?

I think yes, since the code behaves different. Otherwise we could
remove die_nmi() completly and replace it by panic(). But both are
different implementions. Maybe we can merge the code, but I didn't
look at it closly.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

