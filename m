Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab2KPIJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:09:48 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41600 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2KPIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:09:46 -0500
X-AuditID: b753bd60-97251ba000002f78-47-50a5f4c70587
X-AuditID: b753bd60-97251ba000002f78-47-50a5f4c70587
Message-ID: <50A5F4C4.2030909@hitachi.com>
Date: Fri, 16 Nov 2012 17:09:40 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: [RFC PATCH 0/2] kvm/vmx: Output TSC offset
References: <20121114013611.5338.15086.stgit@yunodevel> <20121116031946.GA23939@amt.cnet>
In-Reply-To: <20121116031946.GA23939@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcelo,

Thank you for commenting on my patch set.

(2012/11/16 12:19), Marcelo Tosatti wrote:
> On Wed, Nov 14, 2012 at 10:36:21AM +0900, Yoshihiro YUNOMAE wrote:
[...]
>> In this summary, I suggest the patch which TSC offset for each guest can be
>> output on the host.
>
> The guest TSC can change (for example if TSC scaling is used). Moreover
> TSC offset can change, and you'd have to monitor that. What

Yes, that's true. Changing TSC offset is the key point to use TSC for
merging trace data of guests and the host.

> about a module option so that tsc_offset is written as zero (to be
> used as debugging tool). Then the following restrictions apply:
>
> - TSC must be synchronized across CPUs/VCPUS.
> - TSC must be reliable.
>
> Would that suffice? (a module option to kvm.ko, say zero_tsc_offset).

As you say, the guest TSC can change, so guest TSC needs to meet these
two restrictions to merge the trace data in chronological order.

However, the zero-TSC offset method is not enough, I think.
I will use TSC values as the tracing timestamp not only for debugging
but for failure analysis on actual operations. When we introduce
the zero-TSC offset, normally it will be no problem. However, if
the guest executes write_tsc or the guest works live migration, TSC
offset will be changed. After all, we need to monitor the TSC offset
value.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


