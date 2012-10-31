Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2JaGjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:39:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40117 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab2JaGjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:39:53 -0400
Date: Tue, 30 Oct 2012 23:40:56 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, acme@redhat.com, mingo@kernel.org,
        eranian@google.com, asharma@fb.com,
        Anton Blanchard <anton@au1.ibm.com>, paulus@samba.org,
        mpjohn@us.ibm.com, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] perf: Add a few generic stalled-cycles events
Message-ID: <20121031064056.GA12061@us.ibm.com>
References: <20121012012839.GA15348@us.ibm.com>
 <20121015155534.GR8285@erda.amd.com>
 <20121016100809.GS8285@erda.amd.com>
 <20121016183148.GA25482@us.ibm.com>
 <1351081662.22332.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351081662.22332.13.camel@twins>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103106-5806-0000-0000-00001B39B662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra [peterz@infradead.org] wrote:
| On Tue, 2012-10-16 at 11:31 -0700, Sukadev Bhattiprolu wrote:
| > On a side note, how does the kernel on x86 use the 'config' information in 
| > say /sys/bus/event_source/devices/cpu/format/cccr ? On Power7, the raw
| > code encodes the information such as the PMC to use for the event. Is that
| > how the 'config' info in Intel is used ?
| > 
| > Does the 'config' info change from system to system or is it static for
| > a given event on a given CPU ? 
| 
| Have a look at commits (tip/master):
| 
|   641cc938815dfd09f8fa1ec72deb814f0938ac33
|   a47473939db20e3961b200eb00acf5fcf084d755
|   43c032febde48aabcf6d59f47cdcb7b5debbdc63
| 
| 
| So basically
| 
|  /sys/bus/event_source/devices/cpu/format/event
| 
| contains something like:
| 
|   config:0-7
| 
| Which says that for the 'cpu' PMU, field 'event' fills
| perf_event_attr::config bits 0 through 7 (for type=PERF_TYPE_RAW).
| 
| The perf tool syntax for this is:
| 
|   perf stat -e 'cpu/event=0x3c/'
| 
| This basically allows you to expose bitfields in the 'raw' event format
| for ease of writing raw events. I do not know if the Power PMU has such
| or not.

Thanks for the detailed explanation.

Power does not support this yet, but I have started working on it now.

BTW, does this mean that we can use arch-specific names for the sysfs entries
within:

	/sys/bus/event_source/devices/cpu/events/

So instead of the names I came up with in this patch, stalled-cycles-fixed-point
we could use the name used in the CPU spec - 'cmplu_stall_fxu' in the arch
specific code ?

Sukadev

