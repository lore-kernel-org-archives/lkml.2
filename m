Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0G1Xuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:50:50 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42744 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0G1Xus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=x5lUHX9SmCjxrnzHt7IAT50XfrzklcTTt/9YDY/qCtj0yE9P9xj0XhsRafoXomnZQP
         SgBVDzwwk39akP9M/7t2ZRZOhDNs2hBBjcBXW2210PK23eUI9bHi33KVdY4gIQPjsQdM
         vyYWqmnlG0Xwq/9AspEDsC4X1eim7PDiCpTPc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikZ_RHHv9cudUh8pp9H8MtKO8Rsr+eboupv49xD@mail.gmail.com>
References: <20100727210210.58d3118c@infradead.org>
	<AANLkTikZ_RHHv9cudUh8pp9H8MtKO8Rsr+eboupv49xD@mail.gmail.com>
Date: Wed, 28 Jul 2010 16:50:40 -0700
X-Google-Sender-Auth: Pu__bJS8OGTrYRytzgo0_tNQiAQ
Message-ID: <AANLkTim3h4VNqF97d++k4_4g-4hnw57YXJSQgSEP4S7m@mail.gmail.com>
Subject: Re: [patch] Remove the per cpu tick skew
From: john stultz <johnstul@us.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 1:26 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, Jul 27, 2010 at 9:02 PM, Arjan van de Ven <arjan@infradead.org> wrote:
>> Historically, Linux has tried to make the regular timer tick on the various
>> CPUs not happen at the same time, to avoid contention on xtime_lock.
>>
>> Nowadays, with the tickless kernel, this contention no longer happens
>> since time keeping and updating are done differently. In addition,
>> this skew is actually hurting power consumption in a measurable
>> way on many-core systems.
>>
>
> I'll give it a spin against -rt and see if we show any latency jumps.

In my testing on a 8way box, I didn't see any concerning latencies
with this patch running cyclictest or a FIFO99 gtod loop.

thanks
-john
