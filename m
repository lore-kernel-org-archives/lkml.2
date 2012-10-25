Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992470Ab2JYQ6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:58:31 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39580 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab2JYQ6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:58:09 -0400
From: Benjamin Segall <bsegall@google.com>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Track the runnable average on a per-task entity basis
References: <20120823141506.372695337@google.com>
	<tip-9d85f21c94f7f7a84d0ba686c58aa6d9da58fdbb@git.kernel.org>
	<1351135702.22927.8.camel@liguang.fnst.cn.fujitsu.com>
Date: Thu, 25 Oct 2012 09:58:04 -0700
In-Reply-To: <1351135702.22927.8.camel@liguang.fnst.cn.fujitsu.com> (li
	guang's message of "Thu, 25 Oct 2012 11:28:22 +0800")
Message-ID: <xm26r4om7alf.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

li guang <lig.fnst@cn.fujitsu.com> writes:

> 在 2012-10-24三的 02:43 -0700，tip-bot for Paul Turner写道：
>> +		do {
>> +			if (runnable)
>> +				sa->runnable_avg_sum += delta_w;
>> +			sa->runnable_avg_period += delta_w;
>> +
>> +			/*
>> +			 * Remainder of delta initiates a new period, roll over
>> +			 * the previous.
>> +			 */
>> +			sa->runnable_avg_sum =
>> +				decay_load(sa->runnable_avg_sum, 1);
>
> Is this u0+u1*y+u2*y^2+u3*y^3 ...,
> seems no, this is u0+u1*y+u2*y+u3*y+u4*y ...
>
It is cumulative, so it is u0+y*(u1+y*(u2+..., which is u0+u1*y+u2*y^2+...
