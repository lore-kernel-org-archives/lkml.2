Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0ITIpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 04:45:00 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:43942 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758Ab0ITIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 04:44:59 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275dhz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L91ETG-01-6C7-02
X-M-MSG: 
Date: Mon, 20 Sep 2010 10:41:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
Message-ID: <20100920084139.GN13563@erda.amd.com>
References: <20100910144634.GA1060@elte.hu>
 <20100910155659.GD13563@erda.amd.com>
 <20100911094157.GA11521@elte.hu>
 <20100911114404.GE13563@erda.amd.com>
 <20100911124537.GA22850@elte.hu>
 <20100912095202.GF13563@erda.amd.com>
 <20100913143713.GK13563@erda.amd.com>
 <20100914174132.GN13563@erda.amd.com>
 <20100915162034.GO13563@erda.amd.com>
 <AANLkTikdRh48rf19d3vsd8pEJO0Tvqbnw9_Yd7FaQ3yB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTikdRh48rf19d3vsd8pEJO0Tvqbnw9_Yd7FaQ3yB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.09.10 09:06:09, Stephane Eranian wrote:
> Robert.
> 
> Does it mean that with this patch, we don't need Don's back-to-back NMI patch
> anymore?

No, both fix separate things.

Don's patch is about this problem on Intel systems, where ack'ing the
status late may cause empty nmis:

 http://lkml.org/lkml/2010/8/25/124

My patch fixes a problem that after disabling a counter, it could
still cause a late NMI. It was observed on AMD systems, but may also
be valid for Intel systems.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

