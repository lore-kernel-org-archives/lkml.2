Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0EQMXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:23:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17731 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0EQMXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:23:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=J/sjfhR9WVj9sxLUPdPv54njZcXX1OBDL6LmvbR61IyDqu1sVJtmApqtTUPkdDddk
	+bEnB4slA2smlIDqnAzQA==
MIME-Version: 1.0
In-Reply-To: <1274098175.5605.4661.camel@twins>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <20100517114605.GB5291@nowhere>
	 <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
	 <1274097780.5605.4642.camel@twins>
	 <AANLkTilJH8RnWjBIY7vrOnXi7w1_z8j9_abD-8tuwL-u@mail.gmail.com>
	 <1274098175.5605.4661.camel@twins>
Date: Mon, 17 May 2010 14:23:12 +0200
Message-ID: <AANLkTilg5BipIKkqxRH3Br5oDDluu79EXCW_bNDFR8qA@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 2:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-17 at 14:04 +0200, Stephane Eranian wrote:
>>
>> > So you want to preserve this state for when you munmap() and mmap()
>> > again? The only user of data->lost is writing the PERF_RECORD_LOST
>> > event, which only ever happens when you have pages, so counting it when
>> > there's no pages seems futile.
>>
>> You're right. But couldn't you report lost samples in the buffer header as well?
>
> I guess you could, but what's the point? If you ask for sampling but
> don't provide a buffer you don't get anything -- how's that a surprise?
>
Fine. I'll update the patch to not account for data->lost.
