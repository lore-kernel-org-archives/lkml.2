Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0IAJ0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:26:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0IAJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:26:31 -0400
Message-ID: <4C7E1C36.6070400@redhat.com>
Date: Wed, 01 Sep 2010 12:26:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, kvm-devel <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace/perf_event leak
References: <4C7E11E5.1040402@redhat.com> <1283331868.2059.808.camel@laptop>
In-Reply-To: <1283331868.2059.808.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/01/2010 12:04 PM, Peter Zijlstra wrote:
>
> Does something like the below cure that?
>

Unfortunately not.

> I seem to remember C doesn't make any promises about the order of logic
> statements, hence we need to explicitly pull out that try_module_get()
> so that it evaluates after the rest of the conditions.

&& and || are executed in order (so you can write

    if (p && p->x)

).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

