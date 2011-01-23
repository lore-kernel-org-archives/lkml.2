Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab1AWSBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:01:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1AWSBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:01:33 -0500
X-User-Agent: K-9 Mail for Android
References: <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi> <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <20110121193240.GA13581@Krystal>
In-Reply-To: <20110121193240.GA13581@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: =?US-ASCII?Q?Re=3A_=5Bcpuops_cmpxchg_double_V2_1/4=5D_Gen?= =?US-ASCII?Q?eric_support_for=09this=5Fcpu=5Fcmpxchg=5Fdouble?=
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Jan 2011 10:00:30 -0800
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ae2cc2e9-6516-4acf-bfad-5b6947ef11c4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't apply "packed" to a structure which needs padding!  That's just user error.

"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com> wrote:

>* Tejun Heo (tj@kernel.org) wrote:
>[...]
>> > (note: packed here along with "aligned" does _not_ generate ugly
>> > bytewise read/write memory ops like "packed" alone. The use of
>> > "packed" is to let the compiler down-align the structure to the
>> > value requested, instead of uselessly aligning it on 32-byte if it
>> > chooses to.)
>> 
>> Yeah, good point.  :-)
>
>For the records, I just noticed that "packed, aligned(8)" can generate
>unaligned
>accesses on sparc64 by removing the padding between a "int" and a
>following
>pointer. So we should not use it.
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
