Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab2ALOue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 09:50:34 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:32883 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab2ALOud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 09:50:33 -0500
X-AuditID: b753bd60-98392ba000007b1b-5e-4f0ef33631eb
X-AuditID: b753bd60-98392ba000007b1b-5e-4f0ef33631eb
Message-ID: <4F0EF32F.6060001@hitachi.com>
Date: Thu, 12 Jan 2012 23:50:23 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v8 3.2.0-rc5 9/9] perf: perf interface for uprobes
References: <20111216122756.2085.95791.sendpatchset@srdronam.in.ibm.com> <20111216122951.2085.95511.sendpatchset@srdronam.in.ibm.com> <4F06D22D.9060906@hitachi.com> <20120109112427.GB10189@linux.vnet.ibm.com>
In-Reply-To: <20120109112427.GB10189@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srikar,

(2012/01/09 20:24), Srikar Dronamraju wrote:
>>
>>> +
>>> +static int convert_to_perf_probe_point(struct probe_trace_point *tp,
>>> +					struct perf_probe_point *pp)
>>> +{
>>> +	pp->function = strdup(tp->symbol);
>>> +	if (pp->function == NULL)
>>> +		return -ENOMEM;
>>> +	pp->offset = tp->offset;
>>> +	pp->retprobe = tp->retprobe;
>>> +
>>> +	return 0;
>>> +}
>>
>> This function could be used in kprobe_convert_to_perf_probe() too.
>> In that case, it will be separated as a cleanup from this.
> 
> Do you really want this in a separate patch, since it doesnt make too
> much sense without the uprobes code.

If so, breaking this big patch into small pieces helps
(at least) me to review/maintain the change :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
