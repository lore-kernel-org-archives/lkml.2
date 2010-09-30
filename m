Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0I3IiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:38:18 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:29402
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458Ab0I3IiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:38:17 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zzbb2cK98dNzz1202hzzz32i2a8h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 0,
X-WSS-ID: 0L9JXBH-02-5BR-02
X-M-MSG: 
Date: Thu, 30 Sep 2010 10:38:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: Don Zickus <dzickus@redhat.com>, huang ying <huang.ying.caritas@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100930083806.GU13563@erda.amd.com>
References: <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
 <20100927133816.GP13563@erda.amd.com>
 <20100927152014.GY26290@redhat.com>
 <1285634172.20791.92.camel@yhuang-dev>
 <20100928153247.GL26290@redhat.com>
 <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com>
 <20100930043628.GE26290@redhat.com>
 <1285822630.6944.69.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285822630.6944.69.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.09.10 00:57:10, Huang Ying wrote:
> Yes. Both MCE and perf are CPU features. I think they can be thought as
> optional architectural features. I think it is good to put similar
> features into arch/x86/kernel/cpu instead of traps.c. But if necessary,
> we can put direct call in traps.c instead of notifier block.

As you see it seems not being obviously, what goes here and what goes
there. The approach is wrong. If we want to handle some hardware
feature, we should simply register a handler for this. Implemetations
for unhandled or unrecovered interrupts should be in traps.c. It's
that simple.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

