Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab1JDRQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:16:16 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:21916
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab1JDRQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:16:14 -0400
X-SpamScore: 9
X-BigFish: VPS9(zz98dKc55bszz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LSJXAV-02-FO3-02
X-M-MSG: 
Date: Tue, 4 Oct 2011 19:16:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        acme <acme@ghostprotocols.net>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
Message-ID: <20111004171603.GI21506@erda.amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316778523.9084.17.camel@twins>
 <20110923122014.GP6063@erda.amd.com>
 <1317716839.25926.12.camel@twins>
 <20111004085409.GA18566@elte.hu>
 <m2botwlnfk.fsf@firstfloor.org>
 <1317746709.32543.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1317746709.32543.23.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.11 12:45:09, Peter Zijlstra wrote:
> I would much prefer perf {ibs,pebs} commands implemented in C, so that
> normal people can change/improve them too.

Would a perf {ibs,pebs} be an ascii dump or so? Then I just would
better extend perf-report (-D option) to support decoding of raw
samples from dynamically pmus. Something like:

# perf report -D
[...]
. ... raw event: size 88 bytes
.  0000:  01 00 00 00 02 00 58 00 6d 11 00 00 6d 11 00 00  ......X.m...m...
.  0010:  00 80 86 b7 00 00 00 00 00 10 01 00 00 00 00 00  ................
.  0020:  00 00 00 00 00 00 00 00 2f 6c 69 62 2f 6c 69 62  ......../lib/lib
.  0030:  7a 2e 73 6f 2e 31 2e 32 2e 33 00 00 00 00 00 00  z.so.1.2.3......
.  0040:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.  0050:  00 00 00 00 00 00 00 00                          ........
.  # IBS sample (ibs_fetch):
.  # IbsFetchCtl          = 0x0000000000000000
.  #   IbsFetchMaxCnt=0
.  #   IbsFetchCnt=0
.  #   IbsFetchLat=0
.  #   IbsFetchEn=0
.  #   IbsFetchVal=0
.  #   IbsFetchComp=0
.  #   IbsIcMiss=0
.  #   IbsPhyAddrValid=0
.  #   IbsL1TlbPgSz=0
.  #   IbsL1TlbMiss=0
.  #   IbsL2TlbMiss=0
.  #   IbsRandEn=0
.  # IbsFetchLinAd        = 0x00000000813e8b80
.  #   IbsFetchLinAd=0xffffffff813e8b80
.  # IbsFetchPhysAd       = 0x00000000013e8b80
.  #   IbsFetchPhysAd=0x13e8b80
[...]

(Data decoding not correct in this example.)

This wouln't require architecture specific commands.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

