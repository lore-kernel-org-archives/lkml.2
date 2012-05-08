Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2EHKld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:41:33 -0400
Received: from smtp.nokia.com ([147.243.1.48]:41108 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab2EHKlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:41:32 -0400
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>
CC: <kosaki.motohiro@gmail.com>, <anton.vorontsov@linaro.org>,
        <minchan@kernel.org>, <john.stultz@linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linaro-kernel@lists.linaro.org>,
        <patches@linaro.org>, <kernel-team@android.com>
Subject: RE: [PATCH 3/3] vmevent: Implement special low-memory attribute
Thread-Topic: [PATCH 3/3] vmevent: Implement special low-memory attribute
Thread-Index: AQHNJ54zt9884we850qVfkvWrpHZv5a463aAgAA1ewCABLBlgIAAE/cAgABAG4CAAHaTAIAAp8wAgAAGDoCAAANQAIAAFcOAgAAG5oCAAAPpAIAAA4SAgAAyfPD//+L9gIAANYkw
Date: Tue, 8 May 2012 10:38:41 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB98269045D6465@008-AM1MPN1-003.mgdnok.nokia.com>
References: <20120501132409.GA22894@lizard>	<20120501132620.GC24226@lizard>
	<4FA35A85.4070804@kernel.org>	<20120504073810.GA25175@lizard>
	<CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
	<CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
	<20120507121527.GA19526@lizard>	<4FA82056.2070706@gmail.com>
	<CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com>
	<CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com>
	<CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com>
	<CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com>
	<CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com>
	<4FA8D046.7000808@gmail.com>
	<CAOJsxLGWtJy7q6ij_-tN8nVTr-OXpgdWVkXsOda8S9mJzo7n2w@mail.gmail.com>
	<84FF21A720B0874AA94B46D76DB98269045D63B3@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLEm2LfBB031-pU5Srhr+=DVDCmexZm_UczCzqQ2JmgoRw@mail.gmail.com>
In-Reply-To: <CAOJsxLEm2LfBB031-pU5Srhr+=DVDCmexZm_UczCzqQ2JmgoRw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.82.239]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 May 2012 10:38:42.0759 (UTC) FILETIME=[BD007570:01CD2D06]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: penberg@gmail.com [mailto:penberg@gmail.com] On Behalf Of ext
> Pekka Enberg
> Sent: 08 May, 2012 12:20
...
> On Tue, May 8, 2012 at 12:15 PM,  <leonid.moiseichuk@nokia.com> wrote:
> > I am tracking conversation with quite low understanding how it will be
> > useful for practical needs because user-space developers in 80% cases
> > needs to track simply dirty memory changes i.e. modified pages which cannot
> be dropped.
> 
> The point is to support those cases in such a way that works sanely across
> different architectures and configurations.

Which usually means you need to increase level of abstraction from hugepages, swapped, kernel reclaimable, slab allocated, active memory to used, cache and must-have memory which are common for all platforms. Do you have visibility what do you need to show and how do you will calculate it? Does it possible to do for system, group of processes or particular process?

I implemented system-wide variant because that was a simplest one and most urgent I need. But e.g. to say how much memory consumed particular process in Linux you need to use smaps. Probably vmevent need to have some scratches (aka roadmap) into this direction as well.
