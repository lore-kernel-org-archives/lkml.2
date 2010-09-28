Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab0I1P17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:27:59 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:8753 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0I1P16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:27:58 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9GQY0-01-4E5-02
X-M-MSG: 
Date: Tue, 28 Sep 2010 17:27:33 +0200
From: Robert Richter <robert.richter@amd.com>
To: Huang Ying <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error
 with unknown NMI
Message-ID: <20100928152733.GE13563@erda.amd.com>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com>
 <1285549026-5008-6-git-send-email-ying.huang@intel.com>
 <20100927100901.GC32222@erda.amd.com>
 <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com>
 <20100927133816.GP13563@erda.amd.com>
 <1285636761.20791.133.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285636761.20791.133.camel@yhuang-dev>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.09.10 21:19:21, Huang Ying wrote:
> On Mon, 2010-09-27 at 21:38 +0800, Robert Richter wrote:
> > On 27.09.10 08:47:53, huang ying wrote:
> > 
> > > >>  arch/x86/kernel/hwerr.c    |   55 +++++++++++++++++++++++++++++++++++++++++++++
> > > >
> > > > Instead of creating this file the code should be implemented in
> > > >
> > > >  arch/x86/kernel/cpu/intel.c
> > > >
> > > > Similar AMD NB code is implemented in amd.c and k8.c.
> > > 
> > > Why? This file is not vendor specific.
> > 
> > No, it only implements an Intel specific PCI device, nothing else.
> 
> You can add AMD specific PCI device here too. We will add more device ID
> in the future.

I think it is not worth to introduce this file. There is no generic
code in and we have over places for vendor specific code.

> No. We do NOT catch unknown NMIs for a certain hardware here. We put the
> code here because we think it is general instead of hardware specific.
> 
> It should be a general rule to treat unknown NMI as hardware error. But
> to avoid to confuse some users have broken hardware (which will generate
> unknown NMI not for hardware error), we use a white list (machines with
> HEST or workable chipset via PCI ID).

Ok, a white list makes sense. This was not obvious in your
implementation.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

