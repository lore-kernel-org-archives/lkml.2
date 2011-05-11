Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1EKRxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:53:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42081 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1EKRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:53:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QRrC0So7Jwk8gKfEChzx8V3PD28hRD1s7ZZcc5/JpXzxHCQOjWITpza/vBWSc2csh1
         OXsFnRXJ1P6+xsZdVn8y2XKySbb6soauI8HDvaOml72p5oN+VuGoOil8pc5fNedXg36f
         lKjysNep09HVpavRFYTtKJ1VLqkbi0+tKcsi0=
MIME-Version: 1.0
In-Reply-To: <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
	<BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
Date: Wed, 11 May 2011 21:44:04 +0800
Message-ID: <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
Subject: Re: [PATCH] sched: correct how RT task is picked
From: Hillf Danton <dhillf@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 4:43 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, May 10, 2011 at 9:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> When picking RT task for given CPU,
>> [1] if the cpu is invalid for cpumask test, right result could not be
>
> 'cpu is invalid' means weather we care it or not, it's not real 'invalid'
>
If cpu is not cared, how to determine whether it is allowed for task to run?

>> reached even by further checking nr_cpus_allowed,
>> on the other hand, the input cpu is valid in two cases that
>> pick_next_highest_task_rt() is called, thus the invalid input cpu
>> looks over-concern.
>> [2] if the cpu is valid for cpumask test, further checking
>> nr_cpus_allowed looks overwork, since it is computed based on
>> cpus_allowed,
>
> No, cpumask_test_cpu(cpu, &p->cpus_allowed) doesn't mean
> p->rt.nr_cpus_allowed > 1.
>
If cpu is allowed for task to run, then why more cpus are enforced?

thanks
          Hillf
