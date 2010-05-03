Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab0ECVSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:18:34 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:48448 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab0ECVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:18:32 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz1432P98dN936eM1419M62a3Lzz1202hzz6ff19h2ba5Mz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1V4IM-02-F3X-02
X-M-MSG: 
Date: Mon, 3 May 2010 23:18:20 +0200
From: Robert Richter <robert.richter@amd.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
CC: "Siamashka Siarhei (Nokia-D/Helsinki)" <siarhei.siamashka@nokia.com>,
       "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
       "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] updates for oprofile
Message-ID: <20100503211820.GF5979@erda.amd.com>
References: <20100427152544.GA9063@pcarmody-desktop>
 <20100427174026.GR6450@erda.amd.com>
 <201004272047.52056.siarhei.siamashka@nokia.com>
 <20100428165906.GA21724@erda.amd.com>
 <20100428170915.GF17639@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100428170915.GF17639@pcarmody-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.04.10 12:09:16, Phil Carmody wrote:
> On 28/04/10 18:59 +0200, ext Robert Richter wrote:
> > On 27.04.10 20:47:51, Siarhei Siamashka wrote:
> > > Isn't hrtimer callback function supposed to be only called from IRQ context
> > > after this cleanup: http://lwn.net/Articles/308545/ ?
> > 
> > Yes, the patch is upstream since v2.6.29. Thanks Siarhei.
> > 
> > I will add a null pointer check anyway.
> 
> A few here thrashed around a couple of ideas, and the general consensus 
> was that the following work for us, and is offered for consideration.
> 
> Phil
> 
> 
> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> Date: Tue, 27 Apr 2010 19:28:33 +0300
> Subject: [PATCH v2 1/1] oprofile: HACK - protect from not being in an IRQ context
> 
> http://lkml.org/lkml/2010/4/27/285
> 
> Protect against dereferencing regs when it's NULL, and
> force a magic number into pc to prevent too deep processing.
> This approach permits the dropped samples to be tallied as
> invalid Instruction Pointer events.
> 
> e.g. output from about 15mins at 10kHz sample rate:
> Nr. samples received: 2565380
> Nr. samples lost invalid pc: 4
> 
> Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>

Patch applied to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks Phil!

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

