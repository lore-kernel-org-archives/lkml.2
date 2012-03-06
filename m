Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030422Ab2CFPRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:17:45 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60102 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756823Ab2CFPRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:17:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of eag0628@gmail.com designates 10.224.1.9 as permitted sender) smtp.mail=eag0628@gmail.com; dkim=pass header.i=eag0628@gmail.com
MIME-Version: 1.0
In-Reply-To: <1331031498.11248.273.camel@twins>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	<1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	<1331031498.11248.273.camel@twins>
Date: Tue, 6 Mar 2012 23:17:41 +0800
Message-ID: <CACvQF53k9TQfPnVYA3DPeQbwqiA+4+Q5SqQ2dJSFQFAVmodD3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine call_srcu()
From: Lai Jiangshan <eag0628@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 6:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
>>  /*
>> + * 'return left < right;' but handle the overflow issues.
>> + * The same as 'return (long)(right - left) > 0;' but it cares more.
>
> About what? And why? We do the (long)(a - b) thing all over the kernel,
> why would you care more?

@left is constants of  the callers(callbacks's snapshot), @right
increases very slow.
if (long)(right - left) is a big negative, we have to wait for a long
time in this kinds of overflow.
this kinds of overflow can not happen in this safe_less_than()

>
>> + */
>> +static inline
>> +bool safe_less_than(unsigned long left, unsigned long right, unsigned long max)
>> +{
>> +       unsigned long a = right - left;
>> +       unsigned long b = max - left;
>> +
>> +       return !!a && (a <= b);
>> +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
