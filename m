Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1AUSkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:40:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36835 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1AUSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:40:08 -0500
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com> <alpine.DEB.2.00.1101211121350.15692@router.home> <20110121174236.GA12150@Krystal>
In-Reply-To: <20110121174236.GA12150@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: =?US-ASCII?Q?Re=3A_=5Bcpuops_cmpxchg_double_V2_1/4=5D_Gen?= =?US-ASCII?Q?eric_support_for=09this=5Fcpu=5Fcmpxchg=5Fdouble?=
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 21 Jan 2011 10:31:15 -0800
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8110a580-58bd-4dab-881c-7e69bf75ad96@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What is the problem with passing 128-bit structures by value?  I'm quite sure *that* is okay.

"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com> wrote:

>* Christoph Lameter (cl@linux.com) wrote:
>> On Fri, 21 Jan 2011, H. Peter Anvin wrote:
>> 
>> > We could do cmpxchg with a structure... the problem with a lon int
>type is that Cristoph ran into bugs with __int128 on 64 bits.
>> 
>> We also would need to be pass the structure by value (well its really
>a
>> variable but its like passing by value) in order to be similar to the
>> other this_cpu_ops
>> 
>> You'd want either
>> 
>> DEFINE_PERCPU(struct mycustomdoublestruct, percpu_dd)
>> 
>> this_cpu_cmpxchg_double(percpu_dd, oldword1, oldword2, newword1,
>newword2)
>> 
>> with the problem of type checking
>
>What is the problem with type checking here ?
>
>We could use a gcc builtin like the following to check if the alignment
>of
>"percpu_dd" meets the double-cas requirements:
>
>#define testmacro(a, b) \
>   __builtin_choose_expr(__alignof__(a) >= 2 * sizeof(unsigned long), \
>                              ((a).low) = (b), \    /* success */
>                              ((a).low) = (void) 0) /* compile-error */
>
>> or
>> 
>> this_cpu_cmpxchg_double(percpu_dd, old_dd, new_dd)
>> 
>> with the problem of 128 bit constants/structs passed by value.
>
>Yeah, I guess trying to deal with 128-bit value might be a bit tricky.
>But
>having something sane and with compile-time-checked alignment for the
>percpu_dd
>type is not to be looked over.
>
>Thanks,
>
>Mathieu
>
>-- 
>Mathieu Desnoyers
>Operating System Efficiency R&D Consultant
>EfficiOS Inc.
>http://www.efficios.com

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
