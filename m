Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608Ab0DHVIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:08:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950Ab0DHVIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:08:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kYMgj9cN0I6VBUIHg0OD4nNT5V4/fiV7UdMpPktV/OVUCIIJ6S5cFQ0S/90pZ7VRz
	Cx540XGvgXLQHDDBZkdsQ==
MIME-Version: 1.0
In-Reply-To: <1270760136.20295.3121.camel@laptop>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
Date: Thu, 8 Apr 2010 23:08:34 +0200
Message-ID: <v2xbd4cb8901004081408mf761d04ag5a365d068c58d64b@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
	perf_prepare_sample()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 10:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-08 at 22:45 +0200, Stephane Eranian wrote:
>>       There is a warn_on_once() check for PERF_SAMPLE_RAW which trips
>>       when using PEBS on both Core and Nehalem. Core PEBS sample size is 144
>>       bytes and 176 bytes for Nehalem. Both are multiples of 8, but the size
>>       field is encoded as int, thus the total is never a multiple of 8 which
>>       trips the check. I think the size should have been u64, but now it is
>>       too late to change given it is ABI.
>
> PEBS hasn't seen -linus yet, so we can fix that.
>
Are you suggesting you add some padding the PEBS raw sample you
return as PERF_SAMPLE_RAW? Then you need to define what RAW
actually means? Seems here, it would mean more than what the
HW returns.

> There's various things that do indeed rely on the perf buffer to always
> be u64 aligned, so this warning isn't bogus at all.
>
I assume this has to do with the wrap-around detection.
