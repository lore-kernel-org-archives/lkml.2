Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0DOPQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:16:51 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5783 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0DOPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:16:49 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L0XBRO-01-BA7-02
X-M-MSG: 
Date: Thu, 15 Apr 2010 17:16:33 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] perf: introduce model specific events and AMD IBS
Message-ID: <20100415151633.GN11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271317461.32749.67.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1271317461.32749.67.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Apr 2010 15:16:33.0500 (UTC) FILETIME=[A21229C0:01CADCAE]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.10 09:44:21, Peter Zijlstra wrote:
> On Tue, 2010-04-13 at 22:23 +0200, Robert Richter wrote:
> > This patch series introduces model specific events and impments AMD
> > IBS (Instruction Based Sampling) for perf_events.
> 
> I would much rather it uses the ->precise thing PEBS also uses,
> otherwise we keep growing funny arch extensions and end up with a
> totally fragmented trainwreck of an ABI.

I agree that an exiting flag could be reused. But the naming 'precise'
could be misleading. Maybe we rename it to 'model_spec' or something
else that underlines the idea of having model specific setups.

> > The general approach is to introduce a flag to mark an event as model
> > specific. With that flag set a model specific ibs (raw) config value
> > can be passed to the pmu for setup. When there are ibs samples
> > available, it is sent back as a raw data sample to the userland. So we
> > have a raw config value and raw sampling data. This requires the
> > userland to setup ibs and further extract and process sampling data.
> > 
> > Patches 1-8 rework and refactor the code to prepare the ibs
> > implementation. This is done in patches 9-12.
> > 
> > I will add ibs example code to libpfm4.
> 
> Please add a valid usecase to tools/perf/ instead.

I will also provide an example for tools/perf but reusing libpfm4 was
a first quick solution for me.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

