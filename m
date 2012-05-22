Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2EVDFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 23:05:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab2EVDE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 23:04:59 -0400
Message-ID: <4FBB0250.20100@redhat.com>
Date: Tue, 22 May 2012 00:04:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller
 events
References: <4FB65D52.9060108@redhat.com> <20120518164014.GX20215@aftab.osrc.amd.com> <4FB6866E.7090503@redhat.com> <20120518185258.GE20215@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com> <20120518211211.GA26464@aftab.osrc.amd.com> <20120519092618.GC29991@aftab.osrc.amd.com> <4FBA5F59.5000604@redhat.com> <20120521160041.GJ3334@aftab.osrc.amd.com> <4FBA6FE8.50707@redhat.com> <20120521204042.GA14255@aftab.osrc.amd.com>
In-Reply-To: <20120521204042.GA14255@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<offensive comments skipped>

Em 21-05-2012 17:40, Borislav Petkov escreveu:
> On Mon, May 21, 2012 at 01:40:08PM -0300, Mauro Carvalho Chehab wrote:
>> That's exactly what the latest version of this patch does.
> 
> Really, where is the address field?
> 
> +       TP_PROTO(const unsigned int err_type,
> +                const unsigned int mc_index,
> +                const char *error_msg,
> +                const char *label,
> +                const char *location,
> +                const char *core_detail,
> +                const char *driver_detail),
> 
> 
> [ … ]

The above is not the latest version of it. The latest version is:
	http://www.spinics.net/lists/kernel/msg1343822.html

The definition there is:

+/*
+ * Default error mechanisms for Memory Controller errors (CE and UE)
+ */
+TRACE_EVENT(mc_event,
+
+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
+		 const char *error_msg,
+		 const char *label,
+		 int layer0,
+		 int layer1,
+		 int layer2,
+		 unsigned long pfn,
+		 unsigned long offset,
+		 unsigned long grain,
+		 unsigned long syndrome,
+		 const char *driver_detail),
+
+	TP_ARGS(err_type, mc_index, error_msg, label, layer0, layer1, layer2,
+		pfn, offset, grain, syndrome, driver_detail),

The address is there using the edac way to represent it (page, offset, grain). 

> We're going to have single fields for EDAC-global valid values and leave
> the driver-specific stuff lumped in one char * string.

That's exactly what I said. 

See above. driver_detail is a char string, with
the driver specific stuff. The EDAC global values are represented as-is
without being converted to integers.

Regards,
Mauro
