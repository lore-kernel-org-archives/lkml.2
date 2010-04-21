Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DUQ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:58:58 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:59704 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0DUQ64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:58:56 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz1432P98dN936eM1442J62a3Lzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L18KHT-01-8D0-02
X-M-MSG: 
Date: Wed, 21 Apr 2010 18:58:43 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100421165843.GD6450@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
 <20100420160557.GT11907@erda.amd.com>
 <20100421084700.GU11907@erda.amd.com>
 <o2ibd4cb8901004210202i1ba91c3dlc775a9f7759ece68@mail.gmail.com>
 <20100421092145.GV11907@erda.amd.com>
 <20100421105439.GA6450@erda.amd.com>
 <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <r2sbd4cb8901004210437i343850b4z94ca99b9ec0316b6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Apr 2010 16:58:43.0650 (UTC) FILETIME=[E6675220:01CAE173]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.04.10 13:37:27, Stephane Eranian wrote:
> Why do you need model_spec, in addition to your special encoding?
> 
> >  /*
> > + * Model specific hardware events
> > + *
> > + * With the attr.model_spec bit set we can setup hardware events
> > + * others than generic performance counters. A special PMU 64 bit
> > + * config value can be passed through the perf_event interface. The
> > + * concept of PMU model-specific arguments was practiced already in
> > + * Perfmon2. The type of event (8 bits) is determinded from the config
> > + * value too, bit 32-39 are reserved for this.
> > + */
> Isn't the config field big enough to encode all the information you need?
> In the kernel, you could check bit 32-39 and based on host CPU determine
> whether it refers to IBS or is a bogus value. I am trying to figure out what
> model_spec buys you. I believe RAW does not mean the final value as
> accepted by HW but a value that must be interpreted by the model-specific
> code to eventually come up with a raw HW value. In the current code, the
> RAW value is never passed as is, it is assembled from various bits and
> pieces incl. attr.config of course.

The raw config value without the model_spec bit set would asume a
config value for a generic x86 counter. We could reuse also an unused
bit in this config value, but what if this bit will be somewhen used?
Or, it is available on one hw bot not another? So I found it much
cleaner to introduce this attribute flag that can be reused on other
architectures. Also, you will then have the freedom to implement model
specific generic events without using raw_config. As most pmu features
are setup with a 64 bit config value, I would prefer to have also the
encoding of the model specific event type outside of the config
value. A want to be close to the hw register layout without shifting
bits back and forth. This may also introduce trouble in the future if
we need all 64 bits.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

