Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2DCQKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:10:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab2DCQKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:10:50 -0400
Message-ID: <4F7B20F7.6090306@zytor.com>
Date: Tue, 03 Apr 2012 09:10:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH -tip 00/16] in-kernel x86 disassember
References: <20120401160229.4502.2541.stgit@shimauta> <4F7A21B6.8000700@zytor.com> <20120403073145.GB26826@gmail.com>
In-Reply-To: <20120403073145.GB26826@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 12:31 AM, Ingo Molnar wrote:
> 
> The existing oops setup knob is an early_param() in 
> kernel/panic.c, "oops=".
> 
> I'd suggesting extending that in an obvious way. Currently the 
> only option that exists is "oops=panic", so a comma delimited 
> list of attributes would be the natural extension, allowing:
> 
> 	oops=panic
> 	oops=panic,disasm
> 	oops=disasm
> 
> Detail: it should do a strncmp(5, str, "disas"), so that every 
> usual variant works: oops=disasm, oops=disassemble, etc.
> 
>> [...]  In other words, if *you* are debugging your own kernel, 
>> and don't expect to ship oopses off to someone else.
> 
> Probably a DEBUG .config option as well, so that distros can 
> enable it. OTOH, CONFIG_CMDLINE allows the setting of such 
> parameters as well.
> 

I would say there should be a CONFIG option to build it in, but I'd like
to see an explicit command-line option to enable it.

I *do not* want to see this in distro kernels.  That is all downside.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

