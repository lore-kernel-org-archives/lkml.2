Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2BVIBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:01:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48874 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab2BVIBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:01:40 -0500
References: <cover.1329851692.git.jbaron@redhat.com> <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com> <1329856745.25686.72.camel@gandalf.stny.rr.com> <20120222073251.GB17291@elte.hu> <20120222075334.GA25053@elte.hu>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120222075334.GA25053@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups + docs
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 22 Feb 2012 00:01:03 -0800
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
CC: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        mathieu.desnoyers@efficios.com, davem@davemloft.net,
        ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stupid thought... do we have cases that matter where the bias and default don't agree?

Ingo Molnar <mingo@elte.hu> wrote:

>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> But it is fundamentally mixing execution and *data type* and 
>> it is not conveying the build time bias properly.
>> 
>> So the best high level naming would be something like:
>> 
>> 	struct static_condition static_flag = STATIC_COND_FALSE;
>> 
>> 
>> 	if (very_unlikely(&static_flag)) {
>> 		...
>> 	}
>> 
>> 	...
>> 
>> 	static_cond_inc(&static_flag);
>> 	...
>> 	static_cond_dec(&static_flag);
>
>Btw., I think the modification path could also carry the high 
>cost of modification (stopping all cpus, modifying code, etc.).
>
>This could be done via:
>
>	static_cond_slow_inc(&static_flag);
>	...
>	static_cond_slow_dec(&static_flag);
>
>And if a developer does not notice that 'slow' implies a 
>performance cost, then he probably would have doubly missed this 
>aspect of jump_label_inc()/jump_label_dec().
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
