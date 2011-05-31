Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1EaA5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:57:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56310 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1EaA5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=u7WhAjIQpobOSYdjYg77wXYLzDybzKERofH8vQ0OBCnZw+0ZFBg7vZ0Kw6vpwzBJxZ
         lJFhy3olHiC3aDFkitY1lkXlMKQYfySdIGPIy10PGl/riiSqgG2nk1e/7zTHExnnGZPK
         UA3UqmcSRO4YuZdqJjIBnEZ7QGD/lXjw87U3o=
Message-ID: <4DE4393E.1080703@gmail.com>
Date: Mon, 30 May 2011 18:41:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ashwin Chaugule <ashbertslists@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: perf: h/w counters not counted and no error/info reported to
 user
References: <4DDECFC8.7090903@gmail.com>	<20110527095036.GK21386@elte.hu>	<4DDFBD83.3020105@gmail.com>	<4DDFD2F7.1050305@gmail.com> <BANLkTi=uKSKNJCJquKm44ofMwcTmfwAPyw@mail.gmail.com>
In-Reply-To: <BANLkTi=uKSKNJCJquKm44ofMwcTmfwAPyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/30/2011 03:04 PM, Ashwin Chaugule wrote:
> Hi David,
> 
> On Fri, May 27, 2011 at 12:36 PM, David Ahern <dsahern@gmail.com> wrote:
>>
>> Ok, I got it now. On some occasions for simple programs -- like sleep 1
>> -- the counter reads show:
>>
>> cycles: 0 1066485 0
>>
>> While the counter value is non-0, the time enabled and running values
>> are 0 and those latter two are used by stat to say "not-counted".
> 
> I've seen time-enabled = 0 too, but I suspected that's because on my
> kernel the sched_clock implementation was missing. (defaults to a
> jiffies based timer)

I think in the case of 'perf stat -- sleep 1' it runs so quickly that
sometimes it does not cross timer ticks and the time_enabled comes out 0.

> I saw your patch for initializing the fd's to -1's, but I'm unable to
> see how that makes the value of time-enabled non zero ?

It doesn't. That patch addresses unsupported counters in the default
list (e.g., -ddd on a T9550 Core2Duo). The first open fails (cpu 0,
thread 0) and the entire FD array is not reset to -1 (from its
initialization to 0).

David

> 
> Cheers,
> Ashwin
