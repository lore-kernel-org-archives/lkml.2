Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1KAME6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:04:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36729 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1KAME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:04:57 -0400
X-AuditID: b753bd60-a28adba0000019f4-a1-4eafe0663b68
X-AuditID: b753bd60-a28adba0000019f4-a1-4eafe0663b68
Message-ID: <4EAFE05B.6020607@hitachi.com>
Date: Tue, 01 Nov 2011 21:04:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: call stop_machine_text_poke() on all CPUs
References: <1319702072-32676-1-git-send-email-rabin@rab.in> <4EAA1357.8060802@hitachi.com> <20111028123002.GA3012@debian>
In-Reply-To: <20111028123002.GA3012@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/28 21:30), Rabin Vincent wrote:
> On Fri, Oct 28, 2011 at 11:28:39AM +0900, Masami Hiramatsu wrote:
>> (2011/10/27 16:54), Rabin Vincent wrote:
>>> It appears that stop_machine_text_poke() wants to be called on all CPUs,
>>> like it's done from text_poke_smp().  Fix text_poke_smp_batch() to do
>>> this.
>>
>> cpu_mask==NULL finally falls back to cpu_online_mask, but even though
>> it should be specified correctly.
> 
> Not quite.  Passing NULL to __stop_machine means that the function will
> be called on any one CPU only, while passing cpu_online_mask means that
> the function will be called on all CPUs.  So this patch is a behaviour
> change/bug fix, not just a clarification.

Aah, Right! I just misunderstood.
Then this must be a bugfix!

Thanks!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
