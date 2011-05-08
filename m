Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab1EHIV0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 04:21:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64955 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab1EHIVV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 04:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DYW0RDDj+VSFdj5sq82E86tI/w87K9l7QcHKwSprQ0dx94S+gmhzsb7aDaBsw7ghXp
         UD7os79NJNrDR+9y/42etVTtvdc2ANLbnyr10bTYXSGkCxYKrVv2Ho/UCs1qiuVpXtHH
         uZipIulUxwPpuMt6XCbsoIVY+QsSr1lT/uUwE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105061547150.2451@chino.kir.corp.google.com>
References: <BANLkTi=S_gSvnQimgqrMmq9eWJYDCDRVmA@mail.gmail.com>
	<alpine.DEB.2.00.1105061547150.2451@chino.kir.corp.google.com>
Date: Sun, 8 May 2011 16:21:20 +0800
Message-ID: <BANLkTi=WORnf0PrQZQ79ZpqFv2NaC-dPUg@mail.gmail.com>
Subject: Re: [Question] how to detect mm leaker and kill?
From: Hillf Danton <dhillf@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 6:48 AM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 6 May 2011, Hillf Danton wrote:
>
>> Hi
>>
>> In the scenario that 2GB  physical RAM is available, and there is a
>> database application that eats 1.4GB RAM without leakage already
>> running, another leaker who leaks 4KB an hour is also running, could
>> the leaker be detected and killed in mm/oom_kill.c with default
>> configure when oom happens?
>>
>
> Yes, if you know the database application is going to use 70% of your
> system RAM and you wish to discount that from its memory use when being
> considered for oom kill, set its /proc/pid/oom_score_adj to -700.
>
> This is only possible on 2.6.36 and later kernels when oom_score_adj was
> introduced.
>
> If you'd like to completely disable oom killing, set
> /proc/pid/oom_score_adj to -1000.
>

Thank you very much, David, for cool answer to my question.

Hillf
