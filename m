Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab0CRV3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:29:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:53549 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0CRV3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:29:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SkmR5UVNGsFbdmIfyfCpMT2n7gROHJ+roPgxdAG8dbCX/Pwoh6dIvp34lWZSb1z38
	WLG4XUfwUWV9A29aymb7g==
MIME-Version: 1.0
In-Reply-To: <1268937194.9440.373.camel@laptop>
References: <4ba2317a.8109cc0a.2858.ffffcd0c@mx.google.com>
	 <1268937194.9440.373.camel@laptop>
Date: Thu, 18 Mar 2010 22:29:04 +0100
Message-ID: <bd4cb8901003181429j235ac282pe0440f02b9138015@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix ordering bug in perf_output_sample()
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

On Thu, Mar 18, 2010 at 7:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-03-18 at 14:42 +0200, Stephane Eranian wrote:
>>       In order to parse a sample correctly based on the information
>>       requested via sample_type, the kernel needs to save each component
>>       in a known order. There is no type value saved with each component.
>>       The current convention is that each component is saved according to
>>       the order in enum perf_event_sample_format. But perf_output_sample()
>>       was not completely following this convention, thereby making samples
>>       impossible to parse without internal kernel knowledge.
>>
>>       This patch puts things in the right order.
>
> NAK, not so actually, its in the order specified in the
> PERF_RECORD_SAMPLE comment.
>
And why is that order different than the one in the enum?
