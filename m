Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1HBLaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 07:30:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48229 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab1HBLa3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 07:30:29 -0400
Subject: Re: [PATCH 0/7] perf, x86: Implement AMD IBS
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110801052128.GW4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
	 <1311959236.5890.420.camel@twins>  <20110801052128.GW4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 13:29:55 +0200
Message-ID: <1312284595.1147.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 07:21 +0200, Robert Richter wrote:

> IBS is supposed to be architectural spec'ed, meaning there are no
> family checks. IBS features are detected using cpuid.
> 
> So the version of the raw sampling data format could be specified with
> the u32 capability variable. I could put the caps value to the raw
> sample data too right after the size field. An additional advantage
> would be that 64 bit values are memory alligned then.

Seems like a good filler :-)

> The Branch Target Address register that has been added to newer cpus
> could simply be extended to the raw data sample, the data would still
> be backward compatible. Userland can detect it existence from the
> sample size or (better) from the ibs caps.

Caps would be better.

> Though it is treated architectural, it isn't in the AMD64 Architecture
> Programmer's Manual (APM). The 10h BKDG is a good source, but extended
> IBS features are described in the family 12h bkdg (same as for 15h)
> and the capabilities are in the cpuid spec:
> 
>  http://support.amd.com/us/Processor_TechDocs/41131.pdf
>  http://support.amd.com/us/Processor_TechDocs/25481.pdf 

Right, so comparing Fam10 to Fam12,

+ IbsOpCtl.19:58
+ IbsOpData.38
- IbsOpData2.4:5
+ IbsOpData3.19
+ IbsBrTarget

Curious that they removed a few bits, those don't seem to be enumerated
in the IBS capability field either.
