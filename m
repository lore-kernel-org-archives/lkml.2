Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab2FHHmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:42:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55912 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab2FHHmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:42:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120607224303.GN28225@tassilo.jf.intel.com>
References: <1339108157-30021-1-git-send-email-andi@firstfloor.org>
	<CABPqkBSEknXdTQWCrxeeeFgREX02ARRzxJ8bj6uh+0yOi0nAjg@mail.gmail.com>
	<20120607224303.GN28225@tassilo.jf.intel.com>
Date: Fri, 8 Jun 2012 09:42:42 +0200
Message-ID: <CABPqkBTQMGX8qcy_HapkjabWUS_2hs4kVeEDputL5Kjk1kjMLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf, x86: Add basic Ivy Bridge support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also IVB needs its own pebs_constraint table as there is a new PEBS
event (0xd3):

+struct event_constraint intel_ivb_pebs_event_constraints[] = {
+       INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.ALL */
+       INTEL_EVENT_CONSTRAINT(0xc2, 0xf),    /* UOPS_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xc4, 0xf),    /* BR_INST_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xc5, 0xf),    /* BR_MISP_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xcd, 0x8),    /* MEM_TRANS_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /*
MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+       INTEL_EVENT_CONSTRAINT(0xd3, 0xf), /*
MEM_LOAD_UOPS_LLC_MISS.LOCAL_DRAM */
+       EVENT_CONSTRAINT_END
+};
+


On Fri, Jun 8, 2012 at 12:43 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> But as far as I know for the other generic stall event:
>>                /* UOPS_DISPATCHED.THREAD,c=1,i=1 to count stall cycles*/
>>                 intel_perfmon_event_map[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =
>>                         X86_CONFIG(.event=0xb1, .umask=0x01, .inv=1, .cmask=1);
>
> Okay.  I'll just undefine it.
>
> -Andi
>
>
> --
> ak@linux.intel.com -- Speaking for myself only
